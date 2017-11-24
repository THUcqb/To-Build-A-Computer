library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.utils.all;

entity InstructionDecode is
    generic (
        delay: time
    );
    port (
        clk: in std_logic;

    -- IN
        -- From IF stage
        pc: in std_logic_vector(15 downto 0);
        instruction: in std_logic_vector(15 downto 0);

        -- From Hazard control
        bubble_select: in std_logic;

        -- From write back
        register_from_write_back: in std_logic_vector(2 downto 0);
        data_from_write_back: in std_logic_vector(15 downto 0);
        reg_write: in std_logic;

    -- OUT
        -- Register file
        rx, ry, rz: out std_logic_vector(2 downto 0);
        rx_val, ry_val: out std_logic_vector(15 downto 0);
        -- IMM
        immediate: out std_logic_vector(15 downto 0);

        -- Control
        pc_select: out std_logic;
        branch_pc: out std_logic_vector(15 downto 0);

        control_out_ex: out type_control_ex;
        control_out_mem: out type_control_mem;
        control_out_wb: out type_control_wb
    );
end InstructionDecode;

architecture InstructionDecode_bhv of InstructionDecode is
    component BranchControl is
        port (
        -- IN
            branch_op: in std_logic_vector(4 downto 0);
            zero_flag: in std_logic;

        -- OUT
            pc_select: out std_logic
        );
    end component;

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
            op: in std_logic_vector(4 downto 0);

        -- OUT
            control_out_ex: out type_control_ex;
            control_out_mem: out type_control_mem;
            control_out_wb: out type_control_wb;

            branch_op: out std_logic_vector(4 downto 0)
        );
    end component;

    component Registers is
        generic (
            delay: time
        );
        port (
            clk: in std_logic;
            
        -- IN
            rx, ry: in std_logic_vector(2 downto 0);
            register_from_write_back: in std_logic_vector(2 downto 0);
            data_from_write_back: in std_logic_vector(15 downto 0);

            control_reg_write: in std_logic;

        -- OUT
            rx_val: out std_logic_vector(15 downto 0);
            ry_val: out std_logic_vector(15 downto 0)
        );
    end component;

    signal ex_after_control: type_control_ex;
    signal mem_after_control: type_control_mem;
    signal wb_after_control: type_control_wb;

    signal branch_op: std_logic_vector(4 downto 0);
    signal zero_flag: std_logic;

    signal lock_rx, lock_ry, lock_rz: std_logic_vector(2 downto 0);
    signal lock_rx_val, lock_ry_val: std_logic_vector(15 downto 0);
    signal lock_immediate: std_logic_vector(15 downto 0);

    signal lock_control_out_ex: type_control_ex;
    signal lock_control_out_mem: type_control_mem;
    signal lock_control_out_wb: type_control_wb;

begin
    registers_entity: Registers
        generic map
        (
            delay => delay
        )
        port map
        (
            clk => clk,
            rx => instruction(10 downto 8), ry => instruction(7 downto 5),
            register_from_write_back => register_from_write_back,
            data_from_write_back => data_from_write_back,
            control_reg_write => reg_write,
            rx_val => lock_rx_val, ry_val => lock_ry_val
        );

    controller: Control
        port map
        (
            op => instruction(15 downto 11),
            control_out_wb => wb_after_control,
            control_out_ex => ex_after_control,
            control_out_mem => mem_after_control,
            branch_op => branch_op
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

    branch_control: BranchControl
        port map
        (
            branch_op => branch_op,
            zero_flag => zero_flag,
            pc_select => pc_select
        );

    zero: process(lock_rx_val)
    begin
        if (lock_rx_val = "0000000000000000") then
            zero_flag <= '0';
        else
            zero_flag <= '1';
        end if;
    end process;
 
    imm: process(instruction)
        variable tmp_imm: std_logic_vector(7 downto 0);
    begin
        tmp_imm := instruction(7 downto 0);
        -- TODO: sign extend
    end process;

    -- update output data
    process (clk)
    begin
        if clk'event and clk = '1' then
            rx_val <= lock_rx_val;
            ry_val <= lock_ry_val;
            rx <= lock_rx;
            ry <= lock_ry;
            rz <= lock_rz;
            immediate <= lock_immediate;
            control_out_ex <= lock_control_out_ex;
            control_out_mem <= lock_control_out_mem;
            control_out_wb <= lock_control_out_wb;
        end if;
    end process;

    branch_pc <= pc + lock_immediate;

end InstructionDecode_bhv;