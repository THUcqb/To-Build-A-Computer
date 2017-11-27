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
        if bubble_select = '1' then
            control_out_ex <= control_in_ex;
            control_out_wb <= control_in_wb;
            control_out_mem <= control_in_mem;
        else
            control_out_ex.branch_op <= "000";
            control_out_ex.rx_src <= "000";
            control_out_ex.ry_src <= '0';
            control_out_ex.reg_dst <= "000";
            control_out_ex.alu_op <= "0000";
            control_out_ex.branch <= '0';

            control_out_mem.mem_read <= '0';
            control_out_mem.mem_write <= '0';

            control_out_wb.mem_to_reg <= '1';
            control_out_wb.reg_write <= '0';
    end if;
end process;
end BubbleMaker_bhv;