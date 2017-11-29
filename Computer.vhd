library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use work.utils.all;

entity Computer is

    generic
    (
        N: integer := 1;
        period: time := 20 ns;
        delay_in_registers: time := 5 ns
    );

    port
    (
        -- clock
        clk, rst: in std_logic;

        -- Instruction memory - RAM 2
        instruction_memory_data: inout std_logic_vector(15 downto 0);

        instruction_memory_pin: out type_ram_pin;

        -- Data memory - RAM 1
        data_memory_data: inout std_logic_vector(15 downto 0);

        data_memory_pin: out type_ram_pin

        -- serial port

        --

    );

end Computer;

architecture Computer_beh of Computer is

    component InstructionFetch is
        port (
            -- clock
            clk: in std_logic;

            -- pc value in branch instructions
            branch_pc: in std_logic_vector(15 downto 0);

            -- pc value in jump instructions
            jump_pc: in std_logic_vector(15 downto 0);

            -- address to write an instruction in when executing ASM
            write_address: in std_logic_vector(15 downto 0);
            -- instruction to write when executing ASM
            write_data: in std_logic_vector(15 downto 0);

            -- control signals
            pc_select: in std_logic_vector(1 downto 0);
            pc_write: in std_logic;
            if_id_write: in std_logic;
            im_read: in std_logic;
            im_write: in std_logic;

            -- stage register outputs
            pc: out std_logic_vector(15 downto 0);
            instruction: out std_logic_vector(15 downto 0);

            -- data and address cable of instruction memory
            ram2_data: inout std_logic_vector(15 downto 0);
            ram2_pin: out type_ram_pin
        );
    end component InstructionFetch;

    component InstructionDecode is
        generic
        (
            delay: time
        );
        port
        (
            clk: in std_logic;

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
            rx_val, ry_val: out std_logic_vector(15 downto 0);
            reg_t_val, reg_sp_val, reg_ih_val: out std_logic_vector(15 downto 0);
            id_pc: out std_logic_vector(15 downto 0);

            -- IMM
            immediate: out std_logic_vector(15 downto 0);

            -- Control
            pc_select: out std_logic;

            control_out_ex: out type_control_ex;
            control_out_mem: out type_control_mem;
            control_out_wb: out type_control_wb;

            -- Hazard detection
            id_branch: out std_logic
        );
    end component InstructionDecode;

    component Execute is
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
            pc_select: out std_logic_vector(1 downto 0);
            control_out_mem: out type_control_mem;
            control_out_wb: out type_control_wb

        );
    end component Execute;

    component MemoryAndWriteBack is
        port(
        -- clock
            clk: in std_logic;

        -- IN
            -- Data
            alu_result: in std_logic_vector(15 downto 0);
            write_data: in std_logic_vector(15 downto 0);
            ex_mem_rd: in std_logic_vector(3 downto 0);

            -- Control
            control_in_mem: in type_control_mem;
            control_in_wb: in type_control_wb;

        -- MID - write back
            -- data
            -- data_from_memory: out std_logic_vector(15 downto 0);
            -- data_from_alu_result: out std_logic_vector(15 downto 0);

        -- OUT
            -- data
            data_to_write_back: out std_logic_vector(15 downto 0);
            --
            mem_wb_rd: out std_logic_vector(3 downto 0);
            -- Control
            control_out_wb: out type_control_wb;
            im_read: out std_logic;
            im_write: out std_logic;
            -- Device
            ram1_data: inout std_logic_vector(15 downto 0);
            ram1_pin: out type_ram_pin
        );
    end component MemoryAndWriteBack;

    component Forwarding is
        port(
            -- IN
            id_ex_rx: in std_logic_vector(3 downto 0);
            id_ex_ry: in std_logic_vector(3 downto 0);
            ex_mem_rd: in std_logic_vector(3 downto 0);
            mem_wb_rd: in std_logic_vector(3 downto 0);
            control_ex_mem_wb: in std_logic;
            control_mem_wb_wb: in std_logic;

            -- OUT
            forward_control_x: out std_logic_vector(1 downto 0);
            forward_control_y: out std_logic_vector(1 downto 0)
        );
    end component Forwarding;

    component HazardDetection is
        port(
        -- IN
            -- for load: register src and dest
            if_id_rx: in std_logic_vector(3 downto 0);
            if_id_ry: in std_logic_vector(3 downto 0);
            id_ex_rd: in std_logic_vector(3 downto 0);
            -- mem_read for load and mem_write for sw
            id_ex_control_mem: in type_control_mem;
            -- for branch
            id_branch: in std_logic;
            -- id_ex_branch for branch
            id_ex_control_ex: in type_control_ex;
            -- for sw
            write_address: in std_logic_vector(15 downto 0);

        -- OUT
            pc_write: out std_logic;
            if_id_write: out std_logic;
            bubble_select: out std_logic
        );
    end component HazardDetection;

    -- IF's outputs
    signal if_pc, if_instruction: std_logic_vector(15 downto 0);

    -- ID's outputs
    signal id_rx, id_ry, id_rz: std_logic_vector(3 downto 0);
    signal id_rx_val, id_ry_val: std_logic_vector(15 downto 0);
    signal id_reg_t_val, id_reg_sp_val, id_reg_ih_val: std_logic_vector(15 downto 0);
    signal id_pc: std_logic_vector(15 downto 0);
    signal id_immediate: std_logic_vector(15 downto 0);
    signal id_pc_select: std_logic;
    signal id_control_out_ex: type_control_ex;
    signal id_control_out_mem: type_control_mem;
    signal id_control_out_wb: type_control_wb;
    signal id_branch: std_logic;
    signal id_rx_before_register, id_ry_before_register: std_logic_vector(3 downto 0);

    -- EX's outputs
    signal ex_alu_result: std_logic_vector(15 downto 0);
    signal ex_write_data: std_logic_vector(15 downto 0);
    signal ex_id_ex_rd: std_logic_vector(3 downto 0);
    signal ex_ex_mem_rd: std_logic_vector(3 downto 0);
    signal ex_forwarding_rx: std_logic_vector(3 downto 0);
    signal ex_branch_pc: std_logic_vector(15 downto 0);
    signal ex_jump_pc: std_logic_vector(15 downto 0);
    signal ex_pc_select: std_logic_vector(1 downto 0);
    signal ex_control_out_mem: type_control_mem;
    signal ex_control_out_wb: type_control_wb;
    signal ex_reg_write: std_logic;

    -- MEM and WB's outputs
    signal wb_data_to_write_back: std_logic_vector(15 downto 0);
    signal wb_rd: std_logic_vector(3 downto 0);
    signal wb_control_out_wb: type_control_wb;
    signal wb_reg_write: std_logic;
    signal mem_im_read: std_logic;
    signal mem_im_write: std_logic;

    -- Forwarding's outputs
    signal forward_control_x: std_logic_vector(1 downto 0);
    signal forward_control_y: std_logic_vector(1 downto 0);

    -- HazardDetection's outputs
    signal hazard_pc_write: std_logic;
    signal hazard_if_id_write: std_logic;
    signal hazard_bubble_select: std_logic;
begin
    instruction_fetch: InstructionFetch
        port map
        (
            clk => clk,
            branch_pc => ex_branch_pc,
            jump_pc => ex_jump_pc,
            write_address => ex_alu_result,
            write_data => ex_write_data,
            pc_select => ex_pc_select,
            pc_write => hazard_pc_write,
            if_id_write => hazard_if_id_write,
            im_read => mem_im_read,
            im_write => mem_im_write,
            pc => if_pc,
            instruction => if_instruction,
            ram2_data => instruction_memory_data,
            ram2_pin => instruction_memory_pin
        );

    instruction_decode: InstructionDecode
        generic map
        (
            delay => delay_in_registers
        )
        port map
        (
            clk => clk,
            if_pc => if_pc,
            instruction => if_instruction,
            bubble_select => hazard_bubble_select,
            register_from_write_back => wb_rd,
            data_from_write_back => wb_data_to_write_back,
            reg_write => wb_reg_write,
            rx => id_rx, ry => id_ry, rz => id_rz,
            rx_val => id_rx_val, ry_val => id_ry_val,
            reg_t_val => id_reg_t_val, reg_sp_val => id_reg_sp_val, reg_ih_val => id_reg_ih_val,
            id_pc => id_pc,
            immediate => id_immediate,
            pc_select => id_pc_select,
            control_out_ex => id_control_out_ex,
            control_out_mem => id_control_out_mem,
            control_out_wb => id_control_out_wb,
            id_branch => id_branch
        );
    id_rx_before_register <= "0" & if_instruction(10 downto 8);
    id_ry_before_register <= "0" & if_instruction(7 downto 5);

    execute_unit: Execute
        port map
        (
            clk => clk,
            rx => id_rx, ry => id_ry, rz => id_rz,
            rx_val => id_rx_val, ry_val => id_ry_val,
            sp_val => id_reg_sp_val, ih_val => id_reg_ih_val, t_val => id_reg_t_val,
            pc => id_pc,
            immediate => id_immediate,
            control_in_ex => id_control_out_ex,
            control_in_mem => id_control_out_mem,
            control_in_wb => id_control_out_wb,
            forward_data_from_mem => ex_alu_result,
            forward_data_from_wb => wb_data_to_write_back,
            forward_control_x => forward_control_x,
            forward_control_y => forward_control_y,
            alu_result => ex_alu_result,
            write_data => ex_write_data,
            id_ex_rd => ex_id_ex_rd,
            ex_mem_rd => ex_ex_mem_rd,
            forwarding_rx => ex_forwarding_rx,
            branch_pc => ex_branch_pc,
            jump_pc => ex_jump_pc,
            pc_select => ex_pc_select,
            control_out_mem => ex_control_out_mem,
            control_out_wb => ex_control_out_wb
        );
    ex_reg_write <= ex_control_out_wb.reg_write;

    memory_and_write_back: MemoryAndWriteBack
        port map
        (
            clk => clk,
            alu_result => ex_alu_result,
            write_data => ex_write_data,
            ex_mem_rd => ex_ex_mem_rd,
            control_in_mem => ex_control_out_mem,
            control_in_wb => ex_control_out_wb,
            data_to_write_back => wb_data_to_write_back,
            mem_wb_rd => wb_rd,
            control_out_wb => wb_control_out_wb,
            im_read => mem_im_read,
            im_write => mem_im_write,
            ram1_data => data_memory_data,
            ram1_pin => data_memory_pin
        );
    wb_reg_write <= wb_control_out_wb.reg_write;

    forwarding_unit: Forwarding
        port map
        (
            id_ex_rx => ex_forwarding_rx,
            id_ex_ry => id_ry,
            ex_mem_rd => ex_ex_mem_rd,
            mem_wb_rd => wb_rd,
            control_ex_mem_wb => ex_reg_write,
            control_mem_wb_wb => wb_reg_write,
            forward_control_x => forward_control_x,
            forward_control_y => forward_control_y
        );


    hazard_detection_unit: HazardDetection
        port map
        (
            if_id_rx => id_rx_before_register,
            if_id_ry => id_ry_before_register,
            id_ex_rd => ex_id_ex_rd,
            id_ex_control_mem => id_control_out_mem,
            id_branch => id_branch,
            id_ex_control_ex => id_control_out_ex,
            write_address => ex_jump_pc,
            pc_write => hazard_pc_write,
            if_id_write => hazard_if_id_write,
            bubble_select => hazard_bubble_select
        );
end Computer_beh;
