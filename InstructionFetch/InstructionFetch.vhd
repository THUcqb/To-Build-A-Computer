library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use work.utils.all;

entity InstructionFetch is
    Port (
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
end InstructionFetch;

architecture Behavorial of InstructionFetch is

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

    -- pc + 1
    signal pc_add1: std_logic_vector(15 downto 0);
    -- in and out of pc register
    signal pc_in: std_logic_vector(15 downto 0);
    signal pc_out: std_logic_vector(15 downto 0);
    signal address: std_logic_vector(15 downto 0);

    -- control signal of ram2
    signal control_mem: type_control_mem;

    -- constants: enabled/disabled
    constant enabled: std_logic := '0';
    constant disabled: std_logic := '1';

    signal zero_const_16: std_logic_vector(15 downto 0) := (others => '0');

begin

    -- pc + 1 as a candidate of next pc, and another is branch_pc
    pc_add1 <= pc_out + 1;

    -- contruct control signal object
    control_mem <= (im_read, im_write);
    
    pc_mux: Mux4 port map
    (
        i0 => pc_add1,
        i1 => branch_pc,
        i2 => jump_pc,
        i3 => zero_const_16,
        s => pc_select,
        o => pc_in
    );

    address_mux: Mux2 port map
    (
        i0 => pc_out,
        i1 => write_address,
        s => im_write,
        o => address
    );

    ram2: Memory port map
    (
        control_mem => control_mem,
        address => address,
        write_data => write_data,
        pin => ram2_pin,
        data => ram2_data
    );

    clockUp: process (clk)
    begin

        if (clk'event and clk = '1') then

            -- write mux output into pc register
            if (pc_write = enabled) then
                pc_out <= pc_in;
            end if;

            -- write stage registers
            if (if_id_write = enabled) then
                -- instruction fetched
                instruction <= ram2_data;

                -- pc + 1
                pc <= pc_add1;
            end if;

        end if;

    end process clockUp;


end Behavorial;
