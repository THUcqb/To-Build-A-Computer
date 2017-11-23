library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_logic_ARITH.ALL;
use IEEE.std_logic_UNSIGNED.ALL;

entity Mux3 is
    port (
        i0: in std_logic_vector(15 downto 0);
        i1: in std_logic_vector(15 downto 0);
        i2: in std_logic_vector(15 downto 0);
        s: in std_logic_vector(1 downto 0);

        o: out std_logic_vector(15 downto 0)
    );
end Mux3;

architecture Mux3_beh of Mux3 is

begin

    with s select o <=
        i0 when "00",
        i1 when "01",
        i2 when "10",
        i0 when others;

end Mux3_beh;
