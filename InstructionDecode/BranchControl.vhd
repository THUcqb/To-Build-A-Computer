library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.utils.all;

entity BranchControl is
    port (
    -- IN
        branch_op: in std_logic_vector(4 downto 0);
        zero_flag: in std_logic;

    -- OUT
        pc_select: out std_logic
    );
end BranchControl;

architecture BranchControl_bhv of BranchControl is
begin
end BranchControl_bhv;