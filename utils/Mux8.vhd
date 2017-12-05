library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_logic_ARITH.ALL;
use IEEE.std_logic_UNSIGNED.ALL;

entity Mux8 is
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
end Mux8;

architecture Mux8_beh of Mux8 is

begin

    with s select o <=
        i0 when "000",
        i1 when "001",
        i2 when "010",
        i3 when "011",
        i4 when "100",
        i5 when "101",
        i6 when "110",
        i7 when "111",
        i0 when others;

end Mux8_beh;
