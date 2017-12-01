library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.utils.all;
use work.constant_instruction.all;

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
                imm_chooser <= ADDSP3_imm_chooser;
                id_branch <= ADDSP3_id_branch;
                control_out_ex <= ADDSP3_ex;
                control_out_mem <= ADDSP3_mem;
                control_out_wb <= ADDSP3_wb;

            when "00001" => -- NOP
                imm_chooser <= NOP_imm_chooser;
                id_branch <= NOP_id_branch;
                control_out_ex <= NOP_ex;
                control_out_mem <= NOP_mem;
                control_out_wb <= NOP_wb;

            when "00010" => -- B
                imm_chooser <= B_imm_chooser;
                id_branch <= B_id_branch;
                control_out_ex <= B_ex;
                control_out_mem <= B_mem;
                control_out_wb <= B_wb;


            when "00100" => -- BEQZ
                imm_chooser <= BEQZ_imm_chooser;
                id_branch <= BEQZ_id_branch;
                control_out_ex <= BEQZ_ex;
                control_out_mem <= BEQZ_mem;
                control_out_wb <= BEQZ_wb;

            when "00101" => -- BNEZ
                imm_chooser <= BNEZ_imm_chooser;
                id_branch <= BNEZ_id_branch;
                control_out_ex <= BNEZ_ex;
                control_out_mem <= BNEZ_mem;
                control_out_wb <= BNEZ_wb;

            when "00110" =>
                case op(0 downto 0) is
                    when "0" => -- SLL
                        imm_chooser <= SLL_imm_chooser;
                        id_branch <= SLL_id_branch;
                        control_out_ex <= SLL_ex;
                        control_out_mem <= SLL_mem;
                        control_out_wb <= SLL_wb;

                    when others => -- SRA
                        imm_chooser <= SRA_imm_chooser;
                        id_branch <= SRA_id_branch;
                        control_out_ex <= SRA_ex;
                        control_out_mem <= SRA_mem;
                        control_out_wb <= SRA_wb;
                end case;

            when "01000" => -- ADDIU3
                imm_chooser <= ADDIU3_imm_chooser;
                id_branch <= ADDIU3_id_branch;
                control_out_ex <= ADDIU3_ex;
                control_out_mem <= ADDIU3_mem;
                control_out_wb <= ADDIU3_wb;

            when "01001" => -- ADDIU
                imm_chooser <= ADDIU_imm_chooser;
                id_branch <= ADDIU_id_branch;
                control_out_ex <= ADDIU_ex;
                control_out_mem <= ADDIU_mem;
                control_out_wb <= ADDIU_wb;

            when "01100" =>
                case op(10 downto 8) is
                    when "000" => -- BTEQZ
                        imm_chooser <= BTEQZ_imm_chooser;
                        id_branch <= BTEQZ_id_branch;
                        control_out_ex <= BTEQZ_ex;
                        control_out_mem <= BTEQZ_mem;
                        control_out_wb <= BTEQZ_wb;

                    when "001" => -- BTNEZ
                        imm_chooser <= BTNEZ_imm_chooser;
                        id_branch <= BTNEZ_id_branch;
                        control_out_ex <= BTNEZ_ex;
                        control_out_mem <= BTNEZ_mem;
                        control_out_wb <= BTNEZ_wb;

                    when "011" => -- ADDSP
                        imm_chooser <= ADDSP_imm_chooser;
                        id_branch <= ADDSP_id_branch;
                        control_out_ex <= ADDSP_ex;
                        control_out_mem <= ADDSP_mem;
                        control_out_wb <= ADDSP_wb;

                    when others => -- MTSP
                        imm_chooser <= MTSP_imm_chooser;
                        id_branch <= MTSP_id_branch;
                        control_out_ex <= MTSP_ex;
                        control_out_mem <= MTSP_mem;
                        control_out_wb <= MTSP_wb;

                end case;
            when "01101" => -- LI
                imm_chooser <= LI_imm_chooser;
                id_branch <= LI_id_branch;
                control_out_ex <= LI_ex;
                control_out_mem <= LI_mem;
                control_out_wb <= LI_wb;

            when "01110" => -- CMPI
                imm_chooser <= CMPI_imm_chooser;
                id_branch <= CMPI_id_branch;
                control_out_ex <= CMPI_ex;
                control_out_mem <= CMPI_mem;
                control_out_wb <= CMPI_wb;

            when "10010" => -- LW_SP
                imm_chooser <= LW_SP_imm_chooser;
                id_branch <= LW_SP_id_branch;
                control_out_ex <= LW_SP_ex;
                control_out_mem <= LW_SP_mem;
                control_out_wb <= LW_SP_wb;

            when "10011" => -- LW
                imm_chooser <= LW_imm_chooser;
                id_branch <= LW_id_branch;
                control_out_ex <= LW_ex;
                control_out_mem <= LW_mem;
                control_out_wb <= LW_wb;

            when "11010" => -- SW_SP
                imm_chooser <= SW_SP_imm_chooser;
                id_branch <= SW_SP_id_branch;
                control_out_ex <= SW_SP_ex;
                control_out_mem <= SW_SP_mem;
                control_out_wb <= SW_SP_wb;

            when "11011" => -- SW
                imm_chooser <= SW_imm_chooser;
                id_branch <= SW_id_branch;
                control_out_ex <= SW_ex;
                control_out_mem <= SW_mem;
                control_out_wb <= SW_wb;

            when "11100" =>
                case op(1 downto 1) is
                    when "0" => -- ADDU
                        imm_chooser <= ADDU_imm_chooser;
                        id_branch <= ADDU_id_branch;
                        control_out_ex <= ADDU_ex;
                        control_out_mem <= ADDU_mem;
                        control_out_wb <= ADDU_wb;

                    when others => -- SUBU
                        imm_chooser <= SUBU_imm_chooser;
                        id_branch <= SUBU_id_branch;
                        control_out_ex <= SUBU_ex;
                        control_out_mem <= SUBU_mem;
                        control_out_wb <= SUBU_wb;
                end case;

            when "11101" =>
                case op(1 downto 0) is
                    when "00" =>
                        if op(2 downto 2) = "1" then -- AND
                            imm_chooser <= AND_imm_chooser;
                            id_branch <= AND_id_branch;
                            control_out_ex <= AND_ex;
                            control_out_mem <= AND_mem;
                            control_out_wb <= AND_wb;

                        else
                            if op(6 downto 6) = "0" then -- JR
                                imm_chooser <= JR_imm_chooser;
                                id_branch <= JR_id_branch;
                                control_out_ex <= JR_ex;
                                control_out_mem <= JR_mem;
                                control_out_wb <= JR_wb;

                            else -- MFPC
                                imm_chooser <= MFPC_imm_chooser;
                                id_branch <= MFPC_id_branch;
                                control_out_ex <= MFPC_ex;
                                control_out_mem <= MFPC_mem;
                                control_out_wb <= MFPC_wb;

                            end if;
                        end if;
                    when "01" => -- OR
                        imm_chooser <= OR_imm_chooser;
                        id_branch <= OR_id_branch;
                        control_out_ex <= OR_ex;
                        control_out_mem <= OR_mem;
                        control_out_wb <= OR_wb;

                    when "10" =>
                        if op(3 downto 3) = "0" then -- SLT
                            imm_chooser <= SLT_imm_chooser;
                            id_branch <= SLT_id_branch;
                            control_out_ex <= SLT_ex;
                            control_out_mem <= SLT_mem;
                            control_out_wb <= SLT_wb;

                        else -- CMP
                            imm_chooser <= CMP_imm_chooser;
                            id_branch <= CMP_id_branch;
                            control_out_ex <= CMP_ex;
                            control_out_mem <= CMP_mem;
                            control_out_wb <= CMP_wb;

                        end if;
                    when others => -- SLTU
                        imm_chooser <= SLTU_imm_chooser;
                        id_branch <= SLTU_id_branch;
                        control_out_ex <= SLTU_ex;
                        control_out_mem <= SLTU_mem;
                        control_out_wb <= SLTU_wb;

                end case;
            when others =>
                if op(0 downto 0) = "0" then -- MFIH
                    imm_chooser <= MFIH_imm_chooser;
                    id_branch <= MFIH_id_branch;
                    control_out_ex <= MFIH_ex;
                    control_out_mem <= MFIH_mem;
                    control_out_wb <= MFIH_wb;

                else -- MTIH
                    imm_chooser <= MTIH_imm_chooser;
                    id_branch <= MTIH_id_branch;
                    control_out_ex <= MTIH_ex;
                    control_out_mem <= MTIH_mem;
                    control_out_wb <= MTIH_wb;

                end if;
        end case;
    end process;
end Control_bhv;