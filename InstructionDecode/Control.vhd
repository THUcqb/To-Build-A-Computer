library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.utils.all;

entity Control is
    port (
    -- IN
        op: in std_logic_vector(4 downto 0);

    -- OUT
        control_out_ex: out type_control_ex;
        control_out_mem: out type_control_mem;
        control_out_wb: out type_control_wb;

        id_branch: out std_logic;
        imm_chooser: out std_logic_vector(2 downto 0)
    );
end Control;

architecture Control_bhv of Control is
begin
end Control_bhv;