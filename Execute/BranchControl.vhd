library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity BranchControl is
	port (
	-- IN
		branch_op: in std_logic_vector(2 downto 0);
		zero_flag: in std_logic;

	-- OUT
		pc_select: out std_logic_vector(1 downto 0)
	);
end BranchControl;

architecture BranchControl_beh of BranchControl is

begin
    pc_select <=
    	"00" when (branch_op = "000"
    			   or (branch_op = "001" and zero_flag = '0')
    			   or (branch_op = "010" and zero_flag = '1')) else
    	"01" when (branch_op = "011"
    		       or (branch_op = "001" and zero_flag = '1')
    		       or (branch_op = "010" and zero_flag = '0')) else
    	"10" when (branch_op = "100");

end BranchControl_beh;