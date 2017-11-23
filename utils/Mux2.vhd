library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_logic_ARITH.ALL;
use IEEE.std_logic_UNSIGNED.ALL;

entity Mux2 is
    port (
        input0: in std_logic_vector(15 downto 0);
        input1: in std_logic_vector(15 downto 0);
        mux_select: in std_logic;
        
        output: out std_logic_vector(15 downto 0)
    );
end Mux2;

architecture Mux2_beh of Mux2 is

begin

    with mux_select select output <=
        input0 when '0',
        input1 when '1',
        input0 when others;

end Mux2_beh;
