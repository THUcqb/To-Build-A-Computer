library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Registers is
    generic (
        delay: time
    );
    port (
        clk: in std_logic;
        
    -- IN
        rx, ry: in std_logic_vector(2 downto 0);
        register_from_write_back: in std_logic_vector(2 downto 0);
        data_from_write_back: in std_logic_vector(2 downto 0);

        control_reg_write: in std_logic;

    -- OUT
        rx_val: out std_logic_vector(15 downto 0);
        ry_val: out std_logic_vector(15 downto 0)
    );
end Registers;

architecture Registers_bhv of Regsiters is
begin
end Registers_bhv;