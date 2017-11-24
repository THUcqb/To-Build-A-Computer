library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity InstructionFetch is
    Port (
        -- clock
        clk: in STD_LOGIC;

        -- pc value in branch instructions
        branch_pc: in STD_LOGIC_VECTOR(15 downto 0);

        -- control signals
        pc_select: in STD_LOGIC;
        pc_write: in STD_LOGIC;
        if_id_write: in STD_LOGIC;

        -- stage register outputs
        pc: out STD_LOGIC_VECTOR(15 downto 0);
        instruction: out STD_LOGIC_VECTOR(15 downto 0);

        -- data and address cable of instruction memory
        ram2_data: inout STD_LOGIC_VECTOR(15 downto 0);
        ram2_pin: out type_ram_pin
    );
end InstructionFetch;

architecture Behavorial of InstructionFetch is

    component Mux2 is
        port (
            i0: in std_logic_vector(15 downto 0);
            i1: in std_logic_vector(15 downto 0);
            s: in std_logic;

            o: out std_logic_vector(15 downto 0)
        );
    end component Mux2;

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
    signal pc_add1: STD_LOGIC_VECTOR(15 downto 0);
    -- in and out of pc register
    signal pc_in: STD_LOGIC_VECTOR(15 downto 0);
    signal pc_out: STD_LOGIC_VECTOR(15 downto 0);

    -- constants: enabled/disabled
    constant enabled: STD_LOGIC := '0';
    constant disabled: STD_LOGIC := '1';

begin

    -- pc + 1 as a candidate of next pc, and another is branch_pc
    pc_add1 <= pc_out + 1;
    
    pc_mux: Mux2 port map
    (
        i0 => pc_add1,
        i1 => branch_pc,
        s => pc_select,
        o => pc_in
    );

    ram2: Memory port map
    (
        address => pc_out,
        pin => ram2_pin,
        data => ram2_data,
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
