library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.utils.all;

entity Execute is
    port (
    -- clock
        clk: in std_logic;

    -- IN
        -- Data (black)
        rx, ry, rz: in std_logic_vector(2 downto 0);
        rx_val, ry_val: in std_logic_vector(15 downto 0);
        immediate: in std_logic_vector(15 downto 0);

        -- Control (blue)
        control_in_ex: in type_control_ex;
        control_in_mem: out type_control_mem;
        control_in_wb: out type_control_wb;

        -- Forwarding data
        forward_data_from_mem: in std_logic_vector(15 downto 0);
        forward_data_from_wb: in std_logic_vector(15 downto 0);
        -- Forwarding control
        forward_control_x: in std_logic_vector(1 downto 0);
        forward_control_y: in std_logic_vector(1 downto 0);

    -- OUT
        -- data
        alu_result: out std_logic_vector(15 downto 0);
        write_data: out std_logic_vector(15 downto 0);
        -- register destination
        id_ex_rd: out std_logic_vector(2 downto 0);
        ex_mem_rd: out std_logic_vector(2 downto 0);

        -- control
        control_out_mem: out type_control_mem;
        control_out_wb: out type_control_wb

    );
end entity Execute;

architecture Execute_beh of Execute is

    component ALU is
        port (
        -- IN
            input_x : in std_logic_vector (15 downto 0);
            input_y : in std_logic_vector (15 downto 0);
            op : in std_logic_vector (3 downto 0);

        -- OUT
            alu_result : out std_logic_vector (15 downto 0);
            --Carry Flag
            cf : out std_logic;
            --Zero Flag
            zf : out std_logic;
            --Signed Flag
            sf : out std_logic;
            --Overflow Flag
            vf : out std_logic
        );
    end component ALU;
    
    component ALUControl is
        port (
            alu_op: in std_logic_vector(1 downto 0);
            func: in std_logic_vector(4 downto 0);
            
            op: out std_logic_vector(3 downto 0);
        );
    end component ALUControl;

    component Mux2 is
        port (
            i0: in std_logic_vector(15 downto 0);
            i1: in std_logic_vector(15 downto 0);
            s: in std_logic;

            o: out std_logic_vector(15 downto 0)
        );
    end component Mux2;

    component Mux3 is
        port (
            i0: in std_logic_vector(15 downto 0);
            i1: in std_logic_vector(15 downto 0);
            i2: in std_logic_vector(15 downto 0);
            s: in std_logic_vector(1 downto 0);

            o: out std_logic_vector(15 downto 0)
        );
    end component Mux3;

    signal alu_input_x: std_logic_vector(15 downto 0);
    signal alu_input_y: std_logic_vector(15 downto 0);
    signal alu_result_before_reg: std_logic_vector(15 downto 0);

    signal op: std_logic_vector(3 downto 0);
    signal cf, zf, sf, vf: std_logic;

    signal y_forward_mux_out: std_logic_vector(15 downto 0);
    signal rd_mux_out: std_logic_vector(15 downto 0);

begin

    control_out_mem <= control_in_mem;
    control_out_wb <= control_in_wb;

    id_ex_rd <= rd_mux_out(2 downto 0);

    x_forward_mux: Mux3 port map
    (
        i0 => rx_val,
        i1 => forward_data_from_wb,
        i2 => forward_data_from_mem,
        s => forward_control_x,
        o => alu_input_x
    );

    y_forward_mux: Mux3 port map
    (
        i0 => ry_val,
        i1 => forward_data_from_wb,
        i2 => forward_data_from_mem,
        s => forward_control_y,
        o => y_forward_mux_out
    );

    y_alu_src_mux: Mux2 port map
    (
        i0 => y_forward_mux_out,
        i1 => immediate,
        s => control_in_ex.alu_src,
        o => alu_input_y
    );

    rd_mux: Mux3 port map
    (
        i0 => std_logic_vector(resize(unsigned(rx), 16)),
        i1 => std_logic_vector(resize(unsigned(ry), 16)),
        i2 => std_logic_vector(resize(unsigned(rz), 16)),
        s => control_in_ex.reg_dst,
        o => rd_mux_out
    );

    alu: ALU port map
    (
        input_x => alu_input_x, input_y => alu_input_y,
        op => op,
        alu_result => alu_result_before_reg,
        cf => cf, zf => zf, sf => sf, vf => vf
    );
    
    alu_control: ALUControl port map
    (
        alu_op => control_in_ex.alu_op,
        func => immediate(4 downto 0),
        op => op
    );

    clockUp: process(clk)
    begin

        if (clk'event and clk = '1') then
            alu_result <= alu_result_before_reg;
            write_data <= y_forward_mux_out;
            ex_mem_rd <= rd_mux_out(2 downto 0);
        end if;

    end process clockUp;

end Execute_beh;
