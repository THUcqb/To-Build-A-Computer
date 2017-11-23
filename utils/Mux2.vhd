library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_logic_ARITH.ALL;
use IEEE.std_logic_UNSIGNED.ALL;

entity Mux2 is
    port (
        i0: in std_logic_vector(15 downto 0);
        i1: in std_logic_vector(15 downto 0);
        s: in std_logic;

        o: out std_logic_vector(15 downto 0)
    );
end Mux2;

architecture Mux2_beh of Mux2 is

begin

    with s select o <=
        i0 when '0',
        i1 when '1',
        i0 when others;

end Mux2_beh;
