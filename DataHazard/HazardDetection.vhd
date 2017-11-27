library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use work.utils.all;

entity HazardDetection is
    port(
    -- IN
        -- for load: register src and dest
        if_id_rx: in std_logic_vector(2 downto 0);
        if_id_ry: in std_logic_vector(2 downto 0);
        id_ex_rd: in std_logic_vector(2 downto 0);
        -- mem_read for load and mem_write for sw
        id_ex_control_mem: in type_control_mem;
        -- for branch
        id_branch: in std_logic;
        -- id_ex_branch for branch
        id_ex_control_ex: in type_control_ex;
        -- for sw
        write_address: in std_logic_vector(15 downto 0);

    -- OUT
        pc_write: out std_logic;
        if_id_write: out std_logic;
        bubble_select: out std_logic
    );
end entity HazardDetection;

architecture hazard_detection_beh of HazardDetection is

begin
    process (if_id_rx, if_id_ry, id_ex_rd, id_ex_control_mem,
        id_branch, id_ex_control_ex, write_address)
    begin
        if ((id_ex_control_mem.mem_read = '1' and
            (if_id_rx = id_ex_rd or if_id_ry = id_ex_rd))
            or
            (id_ex_control_mem.mem_write = '1' and write_address(15) = '0')) then
            bubble_select <= '1';
            pc_write <= '0';
            if_id_write <= '0';
        elsif (id_ex_control_ex.id_ex_branch = '1') then
            bubble_select <= '1';
            pc_write <= '1';
            if_id_write <= '1';
        elsif (id_branch = '1') then
            bubble_select <= '0';
            pc_write <= '0';
            if_id_write <= '0';
        else
            bubble_select <= '0';
            pc_write <= '1';
            if_id_write <= '1';
        end if;
    end process;

end architecture hazard_detection_beh;
