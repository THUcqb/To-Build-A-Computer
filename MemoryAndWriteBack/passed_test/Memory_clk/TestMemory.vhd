library ieee;
use ieee.STD_LOGIC_1164.ALL;
use ieee.STD_LOGIC_ARITH.ALL;
use ieee.STD_LOGIC_UNSIGNED.ALL;
use work.utils.all;

--  This is the test unit of Memory with clk automatically refreshing
--  dyp_left <= mem_write = '1' / '0'
--  LED <= address(7 downto 0) & write_data(7 downto 0)
--  sw => mem_write & address(6 downto 0) & write_data(7 downto 0)

--  dyp_right <= '1' if mem_state = mem_st1; '2' if = mem_st2

entity TestMemory is
    port(
    -- clock
        clk, rst: in std_logic;

    -- IN
        -- Data
        sw: in std_logic_vector(15 downto 0);
        -- alu_result: in std_logic_vector(15 downto 0);
        -- write_data: in std_logic_vector(15 downto 0);

        -- Control
        -- sw(15) as control_in_mem
        -- control_in_mem: in type_control_mem;

    -- OUT
        -- Device
        ram1_data: inout std_logic_vector(15 downto 0);
        ram1_pin: out type_ram_pin;
        rdn, wrn: out std_logic;

    -- Test
        dyp_left: out std_logic_vector(0 to 6);
        LED: out std_logic_vector(15 downto 0)
    );

end entity TestMemory;

architecture beh of TestMemory is

    component Memory is
        port(
        -- IN
            clk, rst: in std_logic;
            control_mem: in type_control_mem;
            address, write_data: in std_logic_vector(15 downto 0);

        -- OUT
            pin: out type_ram_pin;
            data: inout std_logic_vector(15 downto 0)
        );
    end component Memory;

    signal control_in_mem: type_control_mem;
    signal address: std_logic_vector(15 downto 0);
    signal write_data: std_logic_vector(15 downto 0);
begin
    address <= "00000000" & '0' & sw(14 downto 8);
    write_data <= "00000000" & sw(7 downto 0);
    control_in_mem.mem_write <= sw(15);
    control_in_mem.mem_read <= not sw(15);
    rdn <= '1';
    wrn <= '0';

    ram: Memory
        port map(
            clk => clk,
            rst => rst,
            control_mem => control_in_mem,
            address => address,
            write_data => write_data,

            pin => ram1_pin,
            data => ram1_data
        );


    LED(15 downto 8) <= address(7 downto 0);
    LED(7 downto 0) <= ram1_data(7 downto 0);
    dyp_left <= "1111110" when control_in_mem.mem_write = '0' else
           "0110000" when control_in_mem.mem_write = '1' else
           "1111111";

end architecture beh;
