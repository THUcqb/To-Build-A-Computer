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
        data_from_write_back: in std_logic_vector(15 downto 0);

        control_reg_write: in std_logic;

    -- OUT
        rx_val: out std_logic_vector(15 downto 0);
        ry_val: out std_logic_vector(15 downto 0)
    );
end Registers;

architecture Registers_bhv of Registers is
    type RegisterArray is array (7 downto 0) of std_logic_vector(15 downto 0);
    signal elements: RegisterArray;
    signal index_rx: integer := 0;
    signal index_ry: integer := 0;
    signal index_write_back: integer := 0;

    function toIndex(rank: std_logic_vector(2 downto 0)) return integer is
    begin
        case rank is
            when "000" => return 0;
            when "001" => return 1;
            when "010" => return 2;
            when "011" => return 3;
            when "100" => return 4;
            when "101" => return 5;
            when "110" => return 6;
            when "111" => return 7;
            when others => return 0;
        end case;
        return 0;
    end toIndex;
begin
    index_rx <= toIndex(rx);
    index_ry <= toIndex(ry);
    index_write_back <= toIndex(register_from_write_back);

end Registers_bhv;