library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_logic_ARITH.ALL;
use IEEE.std_logic_UNSIGNED.ALL;

entity Mux3 is
    port (
        input0: in std_logic_vector(15 downto 0);
        input1: in std_logic_vector(15 downto 0);
        input2: in std_logic_vector(15 downto 0);
        mux_select: in std_logic_vector(1 downto 0);
        
        output: out std_logic_vector(15 downto 0)
    );
end Mux3;

architecture Mux3_beh of Mux3 is

begin

    with mux_select select output <=
        input0 when "00",
        input1 when "01",
        input2 when "10",
        input0 when others;

end Mux3_beh;
