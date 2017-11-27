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
        rx, ry, rz: in std_logic_vector(3 downto 0);
        rx_val, ry_val, sp_val, ih_val, t_val, pc: in std_logic_vector(15 downto 0);
        immediate: in std_logic_vector(15 downto 0);

        -- Control (blue)
        control_in_ex: in type_control_ex;
        control_in_mem: in type_control_mem;
        control_in_wb: in type_control_wb;

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
        id_ex_rd: out std_logic_vector(3 downto 0);
        ex_mem_rd: out std_logic_vector(3 downto 0);
        -- forwarding source
        forwarding_rx: out std_logic_vector(3 downto 0);
        -- pc in branch and jump
        branch_pc: out std_logic_vector(15 downto 0);
        jump_pc: out std_logic_vector(15 downto 0);

        -- control
        pc_select: out std_logic;
        control_out_mem: out type_control_mem;
        control_out_wb: out type_control_wb

    );
end entity Execute;

architecture Execute_beh of Execute is

    component BranchControl is
        port (
        -- IN
            branch_op: in std_logic_vector(1 downto 0);
            zero_flag: in std_logic;

        -- OUT
            pc_select: out std_logic
        );
    end component BranchControl;

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

    component Mux2 is
        port (
            i0: in std_logic_vector(15 downto 0);
            i1: in std_logic_vector(15 downto 0);
            s: in std_logic;

            o: out std_logic_vector(15 downto 0)
        );
    end component Mux2;

    component Mux4 is
        port (
            i0: in std_logic_vector(15 downto 0);
            i1: in std_logic_vector(15 downto 0);
            i2: in std_logic_vector(15 downto 0);
            i3: in std_logic_vector(15 downto 0);
            s: in std_logic_vector(1 downto 0);

            o: out std_logic_vector(15 downto 0)
        );
    end component Mux4;

    component Mux8 is
        port (
            i0: in std_logic_vector(15 downto 0);
            i1: in std_logic_vector(15 downto 0);
            i2: in std_logic_vector(15 downto 0);
            i3: in std_logic_vector(15 downto 0);
            i4: in std_logic_vector(15 downto 0);
            i5: in std_logic_vector(15 downto 0);
            i6: in std_logic_vector(15 downto 0);
            i7: in std_logic_vector(15 downto 0);
            s: in std_logic_vector(2 downto 0);

            o: out std_logic_vector(15 downto 0)
        );
    end component Mux8;

    component Mux8_4bit is
        port (
            i0: in std_logic_vector(3 downto 0);
            i1: in std_logic_vector(3 downto 0);
            i2: in std_logic_vector(3 downto 0);
            i3: in std_logic_vector(3 downto 0);
            i4: in std_logic_vector(3 downto 0);
            i5: in std_logic_vector(3 downto 0);
            i6: in std_logic_vector(3 downto 0);
            i7: in std_logic_vector(3 downto 0);
            s: in std_logic_vector(2 downto 0);

            o: out std_logic_vector(3 downto 0)
        );
    end component Mux8_4bit;

    signal zero_const_16: std_logic_vector(15 downto 0) := (others => '0');
    signal zero_const_4: std_logic_vector(3 downto 0) := (others => '0');

    signal t_rank: std_logic_vector(3 downto 0) := "1000";
    signal sp_rank: std_logic_vector(3 downto 0) := "1001";
    signal ih_rank: std_logic_vector(3 downto 0) := "1010";
    signal pc_rank: std_logic_vector(3 downto 0) := "1011";

    signal alu_input_x: std_logic_vector(15 downto 0);
    signal alu_input_y: std_logic_vector(15 downto 0);
    signal alu_result_before_reg: std_logic_vector(15 downto 0);

    signal op: std_logic_vector(3 downto 0);
    signal cf, zf, sf, vf: std_logic;

    signal zero_flag: std_logic;

    signal id_ex_rd_tmp: std_logic_vector(3 downto 0);
    signal y_forward_mux_out: std_logic_vector(15 downto 0);
    signal x_src_mux_out: std_logic_vector(15 downto 0);

begin

    control_out_mem <= control_in_mem;
    control_out_wb <= control_in_wb;

    id_ex_rd <= id_ex_rd_tmp;

    branch_pc <= pc + immediate;
    jump_pc <= alu_result_before_reg;

    x_src_mux: Mux8 port map
    (
        i0 => rx_val,
        i1 => sp_val,
        i2 => ih_val,
        i3 => pc,
        i4 => t_val,
        i5 => zero_const_16,
        i6 => zero_const_16,
        i7 => zero_const_16,
        s => control_in_ex.rx_src,
        o => x_src_mux_out
    );

    x_forward_mux: Mux4 port map
    (
        i0 => x_src_mux_out,
        i1 => forward_data_from_wb,
        i2 => forward_data_from_mem,
        i3 => zero_const_16,
        s => forward_control_x,
        o => alu_input_x
    );

    y_forward_mux: Mux4 port map
    (
        i0 => ry_val,
        i1 => forward_data_from_wb,
        i2 => forward_data_from_mem,
        i3 => zero_const_16,
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

    rd_mux: Mux8_4bit port map
    (
        i0 => rx,
        i1 => ry,
        i2 => rz,
        i3 => sp_rank,
        i4 => ih_rank,
        i5 => t_rank,
        i6 => zero_const_4,
        i7 => zero_const_4,
        s => control_in_ex.reg_dst,
        o => id_ex_rd_tmp
    );

    x_rank_mux: Mux8_4bit port map
    (
        i0 => rx,
        i1 => sp_rank,
        i2 => ih_rank,
        i3 => pc_rank,
        i4 => t_rank,
        i5 => zero_const_4,
        i6 => zero_const_4,
        i7 => zero_const_4,
        s => control_in_ex.rx_src,
        o => forwarding_rx
    );

    branch_control_component: BranchControl port map
    (
        branch_op => control_in_ex.branch_op,
        zero_flag => zero_flag,
        pc_select => pc_select
    );

    alu_component: ALU port map
    (
        input_x => alu_input_x, input_y => alu_input_y,
        op => control_in_ex.alu_op,
        alu_result => alu_result_before_reg,
        cf => cf, zf => zf, sf => sf, vf => vf
    );

    compZero: process(x_src_mux_out)
    begin

        if (x_src_mux_out = "0000000000000000") then
            zero_flag <= '1';
        else
            zero_flag <= '0';
        end if;

    end process compZero;

    clockUp: process(clk)
    begin

        if (clk'event and clk = '1') then
            alu_result <= alu_result_before_reg;
            write_data <= y_forward_mux_out;
            ex_mem_rd <= id_ex_rd_tmp;
        end if;

    end process clockUp;

end Execute_beh;
