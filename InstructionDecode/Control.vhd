library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.utils.all;

entity Control is
    port (
    -- IN
        op: in std_logic_vector(15 downto 0);

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
    process(op)
    begin
        case op(15 downto 11) is
            when "00000" => -- ADDSP3
            when "00001" => -- NOP
            when "00010" => -- B
            when "00100" => -- BEQZ
            when "00101" => -- BNEZ
            when "00110" =>
                case op(0 downto 0) is
                    when "0" => -- SLL
                    when others => -- SRA
                end case;
            when "01000" => -- ADDIU3
            when "01001" => -- ADDIU
            when "01100" =>
                case op(10 downto 8) is
                    when "000" => -- BTEQZ
                    when "001" => -- BTNEZ
                    when "011" => -- ADDSP
                    when others => -- MTSP
                end case;
            when "01101" => -- LI
            when "01110" => -- CMPI
            when "10010" => -- LW_SP
            when "10011" => -- LW
            when "11010" => -- SW_SP
            when "11011" => -- SW
            when "11100" =>
                case op(1 downto 1) is
                    when "0" => -- ADDU
                    when others => -- SUBU
                end case;
            when "11101" =>
                case op(1 downto 0) is
                    when "00" =>
                        if op(2 downto 2) = "1" then -- ADD
                        else
                            if op(6 downto 6) = "0" then -- JR
                            else -- MFPC
                            end if;
                        end if;
                    when "01" => -- OR
                    when "10" =>
                        if op(3 downto 3) = "0" then -- SLT
                        else -- CMP
                        end if;
                    when others => -- SLTU
                end case;
            when others =>
                if op(0 downto 0) = "0" then -- MFIH
                else -- MTIH
                end if;
        end case;
    end process;
end Control_bhv;