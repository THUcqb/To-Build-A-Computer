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
    -- TODO: remove this placeholder;
    pc_select <= branch_op(1 downto 0);

end BranchControl_beh;