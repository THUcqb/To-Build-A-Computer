library ieee;
use ieee.std_logic_1164.ALL;
use ieee.std_logic_arith.ALL;
use ieee.std_logic_unsigned.ALL;
use work.utils.all;
use work.constant_instruction.all;

entity InstructionDecode is
    port (
        clk: in std_logic;
        rst: in std_logic;

    -- IN
        -- From IF stage
        if_pc: in std_logic_vector(15 downto 0);
        instruction: in std_logic_vector(15 downto 0);

        -- From Hazard control
        bubble_select: in std_logic;

        -- From write back
        register_from_write_back: in std_logic_vector(3 downto 0);
        data_from_write_back: in std_logic_vector(15 downto 0);
        reg_write: in std_logic;

    -- OUT
        -- Register file
        rx, ry, rz: out std_logic_vector(3 downto 0);
        rx_val: out std_logic_vector(15 downto 0);
        ry_val: out std_logic_vector(15 downto 0);
        reg_t_val, reg_sp_val, reg_ih_val: out std_logic_vector(15 downto 0);
        id_pc: out std_logic_vector(15 downto 0);

        -- IMM
        immediate: out std_logic_vector(15 downto 0);

        control_out_ex: out type_control_ex;
        control_out_mem: out type_control_mem;
        control_out_wb: out type_control_wb;

        -- Hazard detection
        id_branch: out std_logic;

    -- Display
        register_file: out RegisterArray
    );
end InstructionDecode;

architecture InstructionDecode_bhv of InstructionDecode is
    component BubbleMaker is
        port (
        -- IN
            control_in_ex: in type_control_ex;
            control_in_mem: in type_control_mem;
            control_in_wb: in type_control_wb;

            bubble_select: in std_logic;

        -- OUT
            control_out_ex: out type_control_ex;
            control_out_mem: out type_control_mem;
            control_out_wb: out type_control_wb
        );
    end component;

    component Control is
        port (
        -- IN
            op: in std_logic_vector(15 downto 0);

        -- OUT
            control_out_ex: out type_control_ex;
            control_out_mem: out type_control_mem;
            control_out_wb: out type_control_wb;

            id_branch: out std_logic;
            imm_chooser: out std_logic_vector(2 downto 0)
        );
    end component;

    component Registers is
        port (
            clk: in std_logic;
            
        -- IN
            rx, ry: in std_logic_vector(3 downto 0);
            register_from_write_back: in std_logic_vector(3 downto 0);
            data_from_write_back: in std_logic_vector(15 downto 0);

            control_reg_write: in std_logic;

        -- OUT
            rx_val: out std_logic_vector(15 downto 0);
            ry_val: out std_logic_vector(15 downto 0);
            reg_t_val: out std_logic_vector(15 downto 0);
            reg_sp_val: out std_logic_vector(15 downto 0);
            reg_ih_val: out std_logic_vector(15 downto 0);

        -- Display
            register_file: out RegisterArray
       );
    end component;

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
    end component;

    signal ex_after_control: type_control_ex;
    signal mem_after_control: type_control_mem;
    signal wb_after_control: type_control_wb;

    signal lock_rx, lock_ry, lock_rz: std_logic_vector(3 downto 0);
    signal lock_rx_val, lock_ry_val, lock_reg_t_val, lock_reg_sp_val, lock_reg_ih_val: std_logic_vector(15 downto 0);
    signal lock_pc: std_logic_vector(15 downto 0);
    signal lock_immediate: std_logic_vector(15 downto 0);

    signal lock_control_out_ex: type_control_ex;
    signal lock_control_out_mem: type_control_mem;
    signal lock_control_out_wb: type_control_wb;

    signal imm_chooser: std_logic_vector(2 downto 0);
    signal i0, i1, i2, i3, i4, i5, i6, i7: std_logic_vector(15 downto 0);

begin
    registers_entity: Registers
        port map
        (
            clk => clk,
            rx => lock_rx, ry => lock_ry,
            register_from_write_back => register_from_write_back,
            data_from_write_back => data_from_write_back,
            control_reg_write => reg_write,
            rx_val => lock_rx_val, ry_val => lock_ry_val,
            reg_t_val => lock_reg_t_val, reg_sp_val => lock_reg_sp_val, reg_ih_val => lock_reg_ih_val,
            register_file => register_file
        );

    controller: Control
        port map
        (
            op => instruction,
            control_out_wb => wb_after_control,
            control_out_ex => ex_after_control,
            control_out_mem => mem_after_control,
            id_branch => id_branch,
            imm_chooser => imm_chooser
        );

    bubble_maker: BubbleMaker
        port map
        (
            control_in_ex => ex_after_control,
            control_in_mem => mem_after_control,
            control_in_wb => wb_after_control,

            control_out_ex => lock_control_out_ex,
            control_out_mem => lock_control_out_mem,
            control_out_wb => lock_control_out_wb,

            bubble_select => bubble_select
        );

    imm: Mux8
        port map
        (
            i0 => i0,
            i1 => i1,
            i2 => i2,
            i3 => i3,
            i4 => i4,
            i5 => i5,
            i6 => i6,
            i7 => i7,
            s => imm_chooser,
            o => lock_immediate
        );
 
    i0 <= sxt(instruction(7 downto 0), 16);
    i1 <= sxt(instruction(10 downto 0), 16);
    i2 <= ext(instruction(4 downto 2), 16);
    i3 <= sxt(instruction(3 downto 0), 16);
    i4 <= ext(instruction(7 downto 0), 16);
    i5 <= sxt(instruction(4 downto 0), 16);
    i6 <= (others => '0');
    i7 <= (others => '1');

    lock_pc <= if_pc;
    lock_rx <= "0" & instruction(10 downto 8);
    lock_ry <= "0" & instruction(7 downto 5);
    lock_rz <= "0" & instruction(4 downto 2);

    -- update output data
    process (rst, clk)
    begin
        if rst = '0' then
            control_out_ex <= NOP_ex;
            control_out_mem <= NOP_mem;
            control_out_wb <= NOP_wb;
        elsif rising_edge(clk) then
            rx_val <= lock_rx_val;
            ry_val <= lock_ry_val;
            rx <= lock_rx;
            ry <= lock_ry;
            rz <= lock_rz;
            immediate <= lock_immediate;
            control_out_ex <= lock_control_out_ex;
            control_out_mem <= lock_control_out_mem;
            control_out_wb <= lock_control_out_wb;
            id_pc <= lock_pc;

            reg_ih_val <= lock_reg_ih_val;
            reg_t_val <= lock_reg_t_val;
            reg_sp_val <= lock_reg_sp_val;
        end if;
    end process;

end InstructionDecode_bhv;
