library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.utils.all;

entity BubbleMaker is
    port (
    -- IN
        control_in_ex: in type_control_ex;
        control_in_mem: in type_control_mem;
        control_in_wb: in type_control_wb

        bubble_select: in std_logic;

    -- OUT
        control_out_ex: out type_control_ex;
        control_out_mem: out type_control_mem;
        control_out_wb: out type_control_wb
    );
end BubbleMaker;

architecture BubbleMaker_bhv of BubbleMaker is
begin
end BubbleMaker_bhv;