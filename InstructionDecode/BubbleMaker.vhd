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
        control_in_wb: in type_control_wb;

        bubble_select: in std_logic;

    -- OUT
        control_out_ex: out type_control_ex;
        control_out_mem: out type_control_mem;
        control_out_wb: out type_control_wb
    );
end BubbleMaker;

architecture BubbleMaker_bhv of BubbleMaker is
begin
    process (bubble_select, control_in_ex, control_in_mem, control_in_wb)
    begin
        if bubble_select = '0' then
            control_out_ex <= control_in_ex;
            control_out_wb <= control_in_wb;
            control_out_mem <= control_in_mem;
        else
            control_out_ex <= type_control_ex_zero;

            control_out_mem <= type_control_mem_zero;

            control_out_wb <= type_control_wb_zero;
    end if;
end process;
end BubbleMaker_bhv;
