library ieee;
use ieee.STD_LOGIC_1164.ALL;
use ieee.STD_LOGIC_ARITH.ALL;
use ieee.STD_LOGIC_UNSIGNED.ALL;
use work.utils.all;

-- This is the top entity of the MEM and WB stage

entity MemoryAndWriteBack is
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

end entity MemoryAndWriteBack;

architecture memory_and_write_back_beh of MemoryAndWriteBack is

    component Memory is
        port(
        -- IN
            control_mem: in type_control_mem;
            address, write_data: in std_logic_vector(15 downto 0);

        -- OUT
            pin: out type_ram_pin;
            data: inout std_logic_vector(15 downto 0)
        );
    end component Memory;

    component Mux2 is
        port (
            i0: in std_logic_vector(15 downto 0);
            i1: in std_logic_vector(15 downto 0);
            s: in std_logic;

            o: out std_logic_vector(15 downto 0)
        );
    end component Mux2;

    -- data_to_write_back mux input
    signal data_from_memory: std_logic_vector(15 downto 0);
    signal data_from_alu_result: std_logic_vector(15 downto 0);

    signal mem_to_reg: std_logic;
begin
    ram1: Memory
        port map(
            control_mem => control_in_mem,
            address => alu_result,
            write_data => write_data,

            pin => ram1_pin,
            data => ram1_data
        );

    mux_data_to_write_back: Mux2
        port map(
            i0 => data_from_memory,
            i1 => data_from_alu_result,
            o => data_to_write_back,
            s => mem_to_reg
        );

    mem_to_reg <= control_in_wb.mem_to_reg;
    
    -- Pass the control signals and some data to the next stage
    -- Including:
        -- WB signal
        -- EX/MEM.rd
        -- alu_result
    PASSING: process (clk)
    begin
        if (rising_edge(clk)) then
            control_out_wb <= control_in_wb;
            mem_wb_rd <= ex_mem_rd;

            data_from_memory <= ram1_data;
            data_from_alu_result <= alu_result;
        end if;
    end process;

end architecture memory_and_write_back_beh;
