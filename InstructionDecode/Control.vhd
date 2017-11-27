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
                imm_chooser <= "000";
                id_branch <= '0';

                control_out_ex.branch_op <= "000";
                control_out_ex.rx_src <= "001";
                control_out_ex.ry_src <= '1';
                control_out_ex.reg_dst <= "000";
                control_out_ex.alu_op <= "0000";
                control_out_ex.branch <= '0';

                control_out_mem.mem_read <= '0';
                control_out_mem.mem_write <= '0';

                control_out_wb.mem_to_reg <= '1';
                control_out_wb.reg_write <= '0';

            when "00001" => -- NOP
                imm_chooser <= "000";
                id_branch <= '0';

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

            when "00010" => -- B
                imm_chooser <= "001";
                id_branch <= '1';

                control_out_ex.branch_op <= "011";
                control_out_ex.rx_src <= "000";
                control_out_ex.ry_src <= '1';
                control_out_ex.reg_dst <= "000";
                control_out_ex.alu_op <= "0000";
                control_out_ex.branch <= '1';

                control_out_mem.mem_read <= '0';
                control_out_mem.mem_write <= '0';

                control_out_wb.mem_to_reg <= '1';
                control_out_wb.reg_write <= '0';

            when "00100" => -- BEQZ
                imm_chooser <= "000";
                id_branch <= '1';

                control_out_ex.branch_op <= "001";
                control_out_ex.rx_src <= "000";
                control_out_ex.ry_src <= '1';
                control_out_ex.reg_dst <= "000";
                control_out_ex.alu_op <= "0000";
                control_out_ex.branch <= '1';

                control_out_mem.mem_read <= '0';
                control_out_mem.mem_write <= '0';

                control_out_wb.mem_to_reg <= '1';
                control_out_wb.reg_write <= '0';

            when "00101" => -- BNEZ
                imm_chooser <= "000";
                id_branch <= '1';

                control_out_ex.branch_op <= "010";
                control_out_ex.rx_src <= "000";
                control_out_ex.ry_src <= '1';
                control_out_ex.reg_dst <= "000";
                control_out_ex.alu_op <= "0000";
                control_out_ex.branch <= '1';

                control_out_mem.mem_read <= '0';
                control_out_mem.mem_write <= '0';

                control_out_wb.mem_to_reg <= '1';
                control_out_wb.reg_write <= '0';

            when "00110" =>
                imm_chooser <= "010";
                id_branch <= '0';

                control_out_ex.branch_op <= "000";
                control_out_ex.rx_src <= "000";
                control_out_ex.ry_src <= '1';
                control_out_ex.reg_dst <= "000";
                control_out_ex.branch <= '0';

                control_out_mem.mem_read <= '0';
                control_out_mem.mem_write <= '0';

                control_out_wb.mem_to_reg <= '1';
                control_out_wb.reg_write <= '1';

                case op(0 downto 0) is
                    when "0" => -- SLL
                        control_out_ex.alu_op <= "0101";
                    when others => -- SRA
                        control_out_ex.alu_op <= "0110";
                end case;

            when "01000" => -- ADDIU3
                imm_chooser <= "011";
                id_branch <= '0';

                control_out_ex.branch_op <= "000";
                control_out_ex.rx_src <= "000";
                control_out_ex.ry_src <= '1';
                control_out_ex.reg_dst <= "001";
                control_out_ex.alu_op <= "0000";
                control_out_ex.branch <= '0';

                control_out_mem.mem_read <= '0';
                control_out_mem.mem_write <= '0';

                control_out_wb.mem_to_reg <= '1';
                control_out_wb.reg_write <= '1';

            when "01001" => -- ADDIU
                imm_chooser <= "000";
                id_branch <= '0';

                control_out_ex.branch_op <= "000";
                control_out_ex.rx_src <= "000";
                control_out_ex.ry_src <= '1';
                control_out_ex.reg_dst <= "000";
                control_out_ex.alu_op <= "0000";
                control_out_ex.branch <= '0';

                control_out_mem.mem_read <= '0';
                control_out_mem.mem_write <= '0';

                control_out_wb.mem_to_reg <= '1';
                control_out_wb.reg_write <= '1';

            when "01100" =>
                case op(10 downto 8) is
                    when "000" => -- BTEQZ
                        imm_chooser <= "000";
                        id_branch <= '1';

                        control_out_ex.branch_op <= "001";
                        control_out_ex.rx_src <= "011";
                        control_out_ex.ry_src <= '1';
                        control_out_ex.reg_dst <= "000";
                        control_out_ex.alu_op <= "0000";
                        control_out_ex.branch <= '1';

                        control_out_mem.mem_read <= '0';
                        control_out_mem.mem_write <= '0';

                        control_out_wb.mem_to_reg <= '1';
                        control_out_wb.reg_write <= '0';

                    when "001" => -- BTNEZ
                        imm_chooser <= "000";
                        id_branch <= '1';

                        control_out_ex.branch_op <= "010";
                        control_out_ex.rx_src <= "011";
                        control_out_ex.ry_src <= '1';
                        control_out_ex.reg_dst <= "000";
                        control_out_ex.alu_op <= "0000";
                        control_out_ex.branch <= '1';

                        control_out_mem.mem_read <= '0';
                        control_out_mem.mem_write <= '0';

                        control_out_wb.mem_to_reg <= '1';
                        control_out_wb.reg_write <= '0';

                    when "011" => -- ADDSP
                        imm_chooser <= "000";
                        id_branch <= '0';

                        control_out_ex.branch_op <= "000";
                        control_out_ex.rx_src <= "001";
                        control_out_ex.ry_src <= '1';
                        control_out_ex.reg_dst <= "011";
                        control_out_ex.alu_op <= "0000";
                        control_out_ex.branch <= '0';

                        control_out_mem.mem_read <= '0';
                        control_out_mem.mem_write <= '0';

                        control_out_wb.mem_to_reg <= '1';
                        control_out_wb.reg_write <= '1';

                    when others => -- MTSP
                        imm_chooser <= "000";
                        id_branch <= '0';

                        control_out_ex.branch_op <= "000";
                        control_out_ex.rx_src <= "000";
                        control_out_ex.ry_src <= '0';
                        control_out_ex.reg_dst <= "011";
                        control_out_ex.alu_op <= "1010";
                        control_out_ex.branch <= '0';

                        control_out_mem.mem_read <= '0';
                        control_out_mem.mem_write <= '0';

                        control_out_wb.mem_to_reg <= '1';
                        control_out_wb.reg_write <= '1';

                end case;
            when "01101" => -- LI
                imm_chooser <= "100";
                id_branch <= '0';

                control_out_ex.branch_op <= "000";
                control_out_ex.rx_src <= "000";
                control_out_ex.ry_src <= '1';
                control_out_ex.reg_dst <= "000";
                control_out_ex.alu_op <= "1010";
                control_out_ex.branch <= '0';

                control_out_mem.mem_read <= '0';
                control_out_mem.mem_write <= '0';

                control_out_wb.mem_to_reg <= '1';
                control_out_wb.reg_write <= '1';

            when "01110" => -- CMPI
                imm_chooser <= "000";
                id_branch <= '0';

                control_out_ex.branch_op <= "000";
                control_out_ex.rx_src <= "000";
                control_out_ex.ry_src <= '1';
                control_out_ex.reg_dst <= "101";
                control_out_ex.alu_op <= "0100";
                control_out_ex.branch <= '0';

                control_out_mem.mem_read <= '0';
                control_out_mem.mem_write <= '0';

                control_out_wb.mem_to_reg <= '1';
                control_out_wb.reg_write <= '1';

            when "10010" => -- LW_SP
                imm_chooser <= "000";
                id_branch <= '0';

                control_out_ex.branch_op <= "000";
                control_out_ex.rx_src <= "001";
                control_out_ex.ry_src <= '1';
                control_out_ex.reg_dst <= "000";
                control_out_ex.alu_op <= "0000";
                control_out_ex.branch <= '0';

                control_out_mem.mem_read <= '1';
                control_out_mem.mem_write <= '0';

                control_out_wb.mem_to_reg <= '0';
                control_out_wb.reg_write <= '1';

            when "10011" => -- LW
                imm_chooser <= "101";
                id_branch <= '0';

                control_out_ex.branch_op <= "000";
                control_out_ex.rx_src <= "000";
                control_out_ex.ry_src <= '1';
                control_out_ex.reg_dst <= "001";
                control_out_ex.alu_op <= "0000";
                control_out_ex.branch <= '0';

                control_out_mem.mem_read <= '1';
                control_out_mem.mem_write <= '0';

                control_out_wb.mem_to_reg <= '0';
                control_out_wb.reg_write <= '1';

            when "11010" => -- SW_SP
                imm_chooser <= "000";
                id_branch <= '0';

                control_out_ex.branch_op <= "000";
                control_out_ex.rx_src <= "001";
                control_out_ex.ry_src <= '1';
                control_out_ex.reg_dst <= "000";
                control_out_ex.alu_op <= "0000";
                control_out_ex.branch <= '0';

                control_out_mem.mem_read <= '0';
                control_out_mem.mem_write <= '1';

                control_out_wb.mem_to_reg <= '1';
                control_out_wb.reg_write <= '0';

            when "11011" => -- SW
                imm_chooser <= "101";
                id_branch <= '0';

                control_out_ex.branch_op <= "000";
                control_out_ex.rx_src <= "000";
                control_out_ex.ry_src <= '1';
                control_out_ex.reg_dst <= "000";
                control_out_ex.alu_op <= "0000";
                control_out_ex.branch <= '0';

                control_out_mem.mem_read <= '0';
                control_out_mem.mem_write <= '1';

                control_out_wb.mem_to_reg <= '1';
                control_out_wb.reg_write <= '0';

            when "11100" =>
                imm_chooser <= "000";
                id_branch <= '0';

                control_out_ex.branch_op <= "000";
                control_out_ex.rx_src <= "000";
                control_out_ex.ry_src <= '0';
                control_out_ex.reg_dst <= "010";
                control_out_ex.branch <= '0';

                control_out_mem.mem_read <= '0';
                control_out_mem.mem_write <= '0';

                control_out_wb.mem_to_reg <= '1';
                control_out_wb.reg_write <= '0';

                case op(1 downto 1) is
                    when "0" => -- ADDU
                        control_out_ex.alu_op <= "0000";
                    when others => -- SUBU
                        control_out_ex.alu_op <= "0001";
                end case;
            when "11101" =>
                case op(1 downto 0) is
                    when "00" =>
                        if op(2 downto 2) = "1" then -- ADD
                            imm_chooser <= "000";
                            id_branch <= '0';

                            control_out_ex.branch_op <= "000";
                            control_out_ex.rx_src <= "000";
                            control_out_ex.ry_src <= '0';
                            control_out_ex.reg_dst <= "000";
                            control_out_ex.alu_op <= "0010";
                            control_out_ex.branch <= '0';

                            control_out_mem.mem_read <= '0';
                            control_out_mem.mem_write <= '0';

                            control_out_wb.mem_to_reg <= '1';
                            control_out_wb.reg_write <= '1';

                        else
                            if op(6 downto 6) = "0" then -- JR
                                imm_chooser <= "000";
                                id_branch <= '1';

                                control_out_ex.branch_op <= "100";
                                control_out_ex.rx_src <= "000";
                                control_out_ex.ry_src <= '0';
                                control_out_ex.reg_dst <= "000";
                                control_out_ex.alu_op <= "1001";
                                control_out_ex.branch <= '1';

                                control_out_mem.mem_read <= '0';
                                control_out_mem.mem_write <= '0';

                                control_out_wb.mem_to_reg <= '1';
                                control_out_wb.reg_write <= '0';

                            else -- MFPC
                                imm_chooser <= "000";
                                id_branch <= '0';

                                control_out_ex.branch_op <= "000";
                                control_out_ex.rx_src <= "100";
                                control_out_ex.ry_src <= '0';
                                control_out_ex.reg_dst <= "000";
                                control_out_ex.alu_op <= "1001";
                                control_out_ex.branch <= '0';

                                control_out_mem.mem_read <= '0';
                                control_out_mem.mem_write <= '0';

                                control_out_wb.mem_to_reg <= '1';
                                control_out_wb.reg_write <= '1';

                            end if;
                        end if;
                    when "01" => -- OR
                        imm_chooser <= "000";
                        id_branch <= '0';

                        control_out_ex.branch_op <= "000";
                        control_out_ex.rx_src <= "000";
                        control_out_ex.ry_src <= '0';
                        control_out_ex.reg_dst <= "000";
                        control_out_ex.alu_op <= "0011";
                        control_out_ex.branch <= '0';

                        control_out_mem.mem_read <= '0';
                        control_out_mem.mem_write <= '0';

                        control_out_wb.mem_to_reg <= '1';
                        control_out_wb.reg_write <= '1';

                    when "10" =>
                        if op(3 downto 3) = "0" then -- SLT
                            imm_chooser <= "000";
                            id_branch <= '0';

                            control_out_ex.branch_op <= "000";
                            control_out_ex.rx_src <= "000";
                            control_out_ex.ry_src <= '0';
                            control_out_ex.reg_dst <= "101";
                            control_out_ex.alu_op <= "1000";
                            control_out_ex.branch <= '0';

                            control_out_mem.mem_read <= '0';
                            control_out_mem.mem_write <= '0';

                            control_out_wb.mem_to_reg <= '1';
                            control_out_wb.reg_write <= '1';

                        else -- CMP
                            imm_chooser <= "000";
                            id_branch <= '0';

                            control_out_ex.branch_op <= "000";
                            control_out_ex.rx_src <= "000";
                            control_out_ex.ry_src <= '0';
                            control_out_ex.reg_dst <= "101";
                            control_out_ex.alu_op <= "0100";
                            control_out_ex.branch <= '0';

                            control_out_mem.mem_read <= '0';
                            control_out_mem.mem_write <= '0';

                            control_out_wb.mem_to_reg <= '1';
                            control_out_wb.reg_write <= '1';

                        end if;
                    when others => -- SLTU
                        imm_chooser <= "000";
                        id_branch <= '0';

                        control_out_ex.branch_op <= "000";
                        control_out_ex.rx_src <= "000";
                        control_out_ex.ry_src <= '0';
                        control_out_ex.reg_dst <= "101";
                        control_out_ex.alu_op <= "0111";
                        control_out_ex.branch <= '0';

                        control_out_mem.mem_read <= '0';
                        control_out_mem.mem_write <= '0';

                        control_out_wb.mem_to_reg <= '1';
                        control_out_wb.reg_write <= '1';

                end case;
            when others =>
                if op(0 downto 0) = "0" then -- MFIH
                    imm_chooser <= "000";
                    id_branch <= '0';

                    control_out_ex.branch_op <= "000";
                    control_out_ex.rx_src <= "010";
                    control_out_ex.ry_src <= '0';
                    control_out_ex.reg_dst <= "000";
                    control_out_ex.alu_op <= "1001";
                    control_out_ex.branch <= '0';

                    control_out_mem.mem_read <= '0';
                    control_out_mem.mem_write <= '0';

                    control_out_wb.mem_to_reg <= '1';
                    control_out_wb.reg_write <= '1';

                else -- MTIH
                    imm_chooser <= "000";
                    id_branch <= '0';

                    control_out_ex.branch_op <= "000";
                    control_out_ex.rx_src <= "000";
                    control_out_ex.ry_src <= '0';
                    control_out_ex.reg_dst <= "100";
                    control_out_ex.alu_op <= "1001";
                    control_out_ex.branch <= '0';

                    control_out_mem.mem_read <= '0';
                    control_out_mem.mem_write <= '0';

                    control_out_wb.mem_to_reg <= '1';
                    control_out_wb.reg_write <= '1';

                end if;
        end case;
    end process;
end Control_bhv;