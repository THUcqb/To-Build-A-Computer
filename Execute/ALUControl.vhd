library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_logic_ARITH.ALL;
use IEEE.std_logic_UNSIGNED.ALL;

entity ALUControl is
    port (
        alu_op: in std_logic_vector(2 downto 0);
        func: in std_logic_vector(4 downto 0);
        
        op: out std_logic_vector(3 downto 0);
    );
end ALUControl;

architecture ALUControl_beh of ALUControl is

begin

end ALUControl_beh;
