library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.utils.all;

entity Forwarding is
    port(
        -- IN
        id_ex_rx: in std_logic_vector(3 downto 0);
        id_ex_ry: in std_logic_vector(3 downto 0);
        ex_mem_rd: in std_logic_vector(3 downto 0);
        mem_wb_rd: in std_logic_vector(3 downto 0);
        control_ex_mem_wb: in std_logic;
        control_mem_wb_wb: in std_logic;

        -- OUT
        forward_control_x: out std_logic_vector(1 downto 0);
        forward_control_y: out std_logic_vector(1 downto 0)
    );
end entity Forwarding;

architecture forwarding_beh of Forwarding is

begin

    -- The expression corresponding to the first true condition is assigned
    forward_control_x <=
        "10" when (control_ex_mem_wb = '1') and (ex_mem_rd = id_ex_rx) else
        "01" when (control_mem_wb_wb = '1') and (mem_wb_rd = id_ex_rx) else
        "00";

    forward_control_y <=
        "10" when (control_ex_mem_wb = '1') and (ex_mem_rd = id_ex_ry) else
        "01" when (control_mem_wb_wb = '1') and (mem_wb_rd = id_ex_ry) else
        "00";

end architecture forwarding_beh;
