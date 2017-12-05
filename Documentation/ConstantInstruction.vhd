library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.utils.all;

package constant_instruction is
    constant ADDSP3_imm_chooser: std_logic_vector(2 downto 0) := "000";

    constant ADDSP3_id_branch: std_logic := '0';

    constant ADDSP3_ex: type_control_ex :=
    (
        branch_op => "000",
        rx_src => "001",
        ry_src => '1',
        reg_dst => "000",
        alu_op => "0000",
        branch => '0'
    );

    constant ADDSP3_mem: type_control_mem :=
    (
        mem_read => '0',
        mem_write => '0'
    );

    constant ADDSP3_wb: type_control_wb :=
    (
        mem_to_reg => '1',
        reg_write => '1'
    );

    constant NOP_imm_chooser: std_logic_vector(2 downto 0) := "000";

    constant NOP_id_branch: std_logic := '0';

    constant NOP_ex: type_control_ex :=
    (
        branch_op => "000",
        rx_src => "000",
        ry_src => '0',
        reg_dst => "000",
        alu_op => "0000",
        branch => '0'
    );

    constant NOP_mem: type_control_mem :=
    (
        mem_read => '0',
        mem_write => '0'
    );

    constant NOP_wb: type_control_wb :=
    (
        mem_to_reg => '1',
        reg_write => '0'
    );

    constant B_imm_chooser: std_logic_vector(2 downto 0) := "001";

    constant B_id_branch: std_logic := '1';

    constant B_ex: type_control_ex :=
    (
        branch_op => "011",
        rx_src => "000",
        ry_src => '1',
        reg_dst => "000",
        alu_op => "0000",
        branch => '1'
    );

    constant B_mem: type_control_mem :=
    (
        mem_read => '0',
        mem_write => '0'
    );

    constant B_wb: type_control_wb :=
    (
        mem_to_reg => '1',
        reg_write => '0'
    );

    constant BEQZ_imm_chooser: std_logic_vector(2 downto 0) := "000";

    constant BEQZ_id_branch: std_logic := '1';

    constant BEQZ_ex: type_control_ex :=
    (
        branch_op => "001",
        rx_src => "000",
        ry_src => '1',
        reg_dst => "000",
        alu_op => "0000",
        branch => '1'
    );

    constant BEQZ_mem: type_control_mem :=
    (
        mem_read => '0',
        mem_write => '0'
    );

    constant BEQZ_wb: type_control_wb :=
    (
        mem_to_reg => '1',
        reg_write => '0'
    );

    constant BNEZ_imm_chooser: std_logic_vector(2 downto 0) := "000";

    constant BNEZ_id_branch: std_logic := '1';

    constant BNEZ_ex: type_control_ex :=
    (
        branch_op => "010",
        rx_src => "000",
        ry_src => '1',
        reg_dst => "000",
        alu_op => "0000",
        branch => '1'
    );

    constant BNEZ_mem: type_control_mem :=
    (
        mem_read => '0',
        mem_write => '0'
    );

    constant BNEZ_wb: type_control_wb :=
    (
        mem_to_reg => '1',
        reg_write => '0'
    );

    constant SLL_imm_chooser: std_logic_vector(2 downto 0) := "010";

    constant SLL_id_branch: std_logic := '0';

    constant SLL_ex: type_control_ex :=
    (
        branch_op => "000",
        rx_src => "000",
        ry_src => '1',
        reg_dst => "000",
        alu_op => "0101",
        branch => '0'
    );

    constant SLL_mem: type_control_mem :=
    (
        mem_read => '0',
        mem_write => '0'
    );

    constant SLL_wb: type_control_wb :=
    (
        mem_to_reg => '1',
        reg_write => '1'
    );

    constant SRA_imm_chooser: std_logic_vector(2 downto 0) := "010";

    constant SRA_id_branch: std_logic := '0';

    constant SRA_ex: type_control_ex :=
    (
        branch_op => "000",
        rx_src => "000",
        ry_src => '1',
        reg_dst => "000",
        alu_op => "0110",
        branch => '0'
    );

    constant SRA_mem: type_control_mem :=
    (
        mem_read => '0',
        mem_write => '0'
    );

    constant SRA_wb: type_control_wb :=
    (
        mem_to_reg => '1',
        reg_write => '1'
    );

    constant ADDIU3_imm_chooser: std_logic_vector(2 downto 0) := "011";

    constant ADDIU3_id_branch: std_logic := '0';

    constant ADDIU3_ex: type_control_ex :=
    (
        branch_op => "000",
        rx_src => "000",
        ry_src => '1',
        reg_dst => "001",
        alu_op => "0000",
        branch => '0'
    );

    constant ADDIU3_mem: type_control_mem :=
    (
        mem_read => '0',
        mem_write => '0'
    );

    constant ADDIU3_wb: type_control_wb :=
    (
        mem_to_reg => '1',
        reg_write => '1'
    );

    constant ADDIU_imm_chooser: std_logic_vector(2 downto 0) := "000";

    constant ADDIU_id_branch: std_logic := '0';

    constant ADDIU_ex: type_control_ex :=
    (
        branch_op => "000",
        rx_src => "000",
        ry_src => '1',
        reg_dst => "000",
        alu_op => "0000",
        branch => '0'
    );

    constant ADDIU_mem: type_control_mem :=
    (
        mem_read => '0',
        mem_write => '0'
    );

    constant ADDIU_wb: type_control_wb :=
    (
        mem_to_reg => '1',
        reg_write => '1'
    );

    constant BTEQZ_imm_chooser: std_logic_vector(2 downto 0) := "000";

    constant BTEQZ_id_branch: std_logic := '1';

    constant BTEQZ_ex: type_control_ex :=
    (
        branch_op => "001",
        rx_src => "100",
        ry_src => '1',
        reg_dst => "000",
        alu_op => "0000",
        branch => '1'
    );

    constant BTEQZ_mem: type_control_mem :=
    (
        mem_read => '0',
        mem_write => '0'
    );

    constant BTEQZ_wb: type_control_wb :=
    (
        mem_to_reg => '1',
        reg_write => '0'
    );

    constant BTNEZ_imm_chooser: std_logic_vector(2 downto 0) := "000";

    constant BTNEZ_id_branch: std_logic := '1';

    constant BTNEZ_ex: type_control_ex :=
    (
        branch_op => "010",
        rx_src => "100",
        ry_src => '1',
        reg_dst => "000",
        alu_op => "0000",
        branch => '1'
    );

    constant BTNEZ_mem: type_control_mem :=
    (
        mem_read => '0',
        mem_write => '0'
    );

    constant BTNEZ_wb: type_control_wb :=
    (
        mem_to_reg => '1',
        reg_write => '0'
    );

    constant ADDSP_imm_chooser: std_logic_vector(2 downto 0) := "000";

    constant ADDSP_id_branch: std_logic := '0';

    constant ADDSP_ex: type_control_ex :=
    (
        branch_op => "000",
        rx_src => "001",
        ry_src => '1',
        reg_dst => "011",
        alu_op => "0000",
        branch => '0'
    );

    constant ADDSP_mem: type_control_mem :=
    (
        mem_read => '0',
        mem_write => '0'
    );

    constant ADDSP_wb: type_control_wb :=
    (
        mem_to_reg => '1',
        reg_write => '1'
    );

    constant MTSP_imm_chooser: std_logic_vector(2 downto 0) := "000";

    constant MTSP_id_branch: std_logic := '0';

    constant MTSP_ex: type_control_ex :=
    (
        branch_op => "000",
        rx_src => "000",
        ry_src => '0',
        reg_dst => "011",
        alu_op => "1010",
        branch => '0'
    );

    constant MTSP_mem: type_control_mem :=
    (
        mem_read => '0',
        mem_write => '0'
    );

    constant MTSP_wb: type_control_wb :=
    (
        mem_to_reg => '1',
        reg_write => '1'
    );

    constant LI_imm_chooser: std_logic_vector(2 downto 0) := "100";

    constant LI_id_branch: std_logic := '0';

    constant LI_ex: type_control_ex :=
    (
        branch_op => "000",
        rx_src => "000",
        ry_src => '1',
        reg_dst => "000",
        alu_op => "1010",
        branch => '0'
    );

    constant LI_mem: type_control_mem :=
    (
        mem_read => '0',
        mem_write => '0'
    );

    constant LI_wb: type_control_wb :=
    (
        mem_to_reg => '1',
        reg_write => '1'
    );

    constant CMPI_imm_chooser: std_logic_vector(2 downto 0) := "000";

    constant CMPI_id_branch: std_logic := '0';

    constant CMPI_ex: type_control_ex :=
    (
        branch_op => "000",
        rx_src => "000",
        ry_src => '1',
        reg_dst => "101",
        alu_op => "0100",
        branch => '0'
    );

    constant CMPI_mem: type_control_mem :=
    (
        mem_read => '0',
        mem_write => '0'
    );

    constant CMPI_wb: type_control_wb :=
    (
        mem_to_reg => '1',
        reg_write => '1'
    );

    constant LW_SP_imm_chooser: std_logic_vector(2 downto 0) := "000";

    constant LW_SP_id_branch: std_logic := '0';

    constant LW_SP_ex: type_control_ex :=
    (
        branch_op => "000",
        rx_src => "001",
        ry_src => '1',
        reg_dst => "000",
        alu_op => "0000",
        branch => '0'
    );

    constant LW_SP_mem: type_control_mem :=
    (
        mem_read => '1',
        mem_write => '0'
    );

    constant LW_SP_wb: type_control_wb :=
    (
        mem_to_reg => '0',
        reg_write => '1'
    );

    constant LW_imm_chooser: std_logic_vector(2 downto 0) := "101";

    constant LW_id_branch: std_logic := '0';

    constant LW_ex: type_control_ex :=
    (
        branch_op => "000",
        rx_src => "000",
        ry_src => '1',
        reg_dst => "001",
        alu_op => "0000",
        branch => '0'
    );

    constant LW_mem: type_control_mem :=
    (
        mem_read => '1',
        mem_write => '0'
    );

    constant LW_wb: type_control_wb :=
    (
        mem_to_reg => '0',
        reg_write => '1'
    );

    constant SW_SP_imm_chooser: std_logic_vector(2 downto 0) := "000";

    constant SW_SP_id_branch: std_logic := '0';

    constant SW_SP_ex: type_control_ex :=
    (
        branch_op => "000",
        rx_src => "001",
        ry_src => '1',
        reg_dst => "000",
        alu_op => "0000",
        branch => '0'
    );

    constant SW_SP_mem: type_control_mem :=
    (
        mem_read => '0',
        mem_write => '1'
    );

    constant SW_SP_wb: type_control_wb :=
    (
        mem_to_reg => '1',
        reg_write => '0'
    );

    constant SW_imm_chooser: std_logic_vector(2 downto 0) := "101";

    constant SW_id_branch: std_logic := '0';

    constant SW_ex: type_control_ex :=
    (
        branch_op => "000",
        rx_src => "000",
        ry_src => '1',
        reg_dst => "000",
        alu_op => "0000",
        branch => '0'
    );

    constant SW_mem: type_control_mem :=
    (
        mem_read => '0',
        mem_write => '1'
    );

    constant SW_wb: type_control_wb :=
    (
        mem_to_reg => '1',
        reg_write => '0'
    );

    constant ADDU_imm_chooser: std_logic_vector(2 downto 0) := "000";

    constant ADDU_id_branch: std_logic := '0';

    constant ADDU_ex: type_control_ex :=
    (
        branch_op => "000",
        rx_src => "000",
        ry_src => '0',
        reg_dst => "010",
        alu_op => "0000",
        branch => '0'
    );

    constant ADDU_mem: type_control_mem :=
    (
        mem_read => '0',
        mem_write => '0'
    );

    constant ADDU_wb: type_control_wb :=
    (
        mem_to_reg => '1',
        reg_write => '1'
    );

    constant SUBU_imm_chooser: std_logic_vector(2 downto 0) := "000";

    constant SUBU_id_branch: std_logic := '0';

    constant SUBU_ex: type_control_ex :=
    (
        branch_op => "000",
        rx_src => "000",
        ry_src => '0',
        reg_dst => "010",
        alu_op => "0001",
        branch => '0'
    );

    constant SUBU_mem: type_control_mem :=
    (
        mem_read => '0',
        mem_write => '0'
    );

    constant SUBU_wb: type_control_wb :=
    (
        mem_to_reg => '1',
        reg_write => '1'
    );

    constant JR_imm_chooser: std_logic_vector(2 downto 0) := "000";

    constant JR_id_branch: std_logic := '1';

    constant JR_ex: type_control_ex :=
    (
        branch_op => "100",
        rx_src => "000",
        ry_src => '0',
        reg_dst => "000",
        alu_op => "1001",
        branch => '1'
    );

    constant JR_mem: type_control_mem :=
    (
        mem_read => '0',
        mem_write => '0'
    );

    constant JR_wb: type_control_wb :=
    (
        mem_to_reg => '1',
        reg_write => '0'
    );

    constant MFPC_imm_chooser: std_logic_vector(2 downto 0) := "000";

    constant MFPC_id_branch: std_logic := '0';

    constant MFPC_ex: type_control_ex :=
    (
        branch_op => "000",
        rx_src => "011",
        ry_src => '0',
        reg_dst => "000",
        alu_op => "1001",
        branch => '0'
    );

    constant MFPC_mem: type_control_mem :=
    (
        mem_read => '0',
        mem_write => '0'
    );

    constant MFPC_wb: type_control_wb :=
    (
        mem_to_reg => '1',
        reg_write => '1'
    );

    constant AND_imm_chooser: std_logic_vector(2 downto 0) := "000";

    constant AND_id_branch: std_logic := '0';

    constant AND_ex: type_control_ex :=
    (
        branch_op => "000",
        rx_src => "000",
        ry_src => '0',
        reg_dst => "000",
        alu_op => "0010",
        branch => '0'
    );

    constant AND_mem: type_control_mem :=
    (
        mem_read => '0',
        mem_write => '0'
    );

    constant AND_wb: type_control_wb :=
    (
        mem_to_reg => '1',
        reg_write => '1'
    );

    constant OR_imm_chooser: std_logic_vector(2 downto 0) := "000";

    constant OR_id_branch: std_logic := '0';

    constant OR_ex: type_control_ex :=
    (
        branch_op => "000",
        rx_src => "000",
        ry_src => '0',
        reg_dst => "000",
        alu_op => "0011",
        branch => '0'
    );

    constant OR_mem: type_control_mem :=
    (
        mem_read => '0',
        mem_write => '0'
    );

    constant OR_wb: type_control_wb :=
    (
        mem_to_reg => '1',
        reg_write => '1'
    );

    constant SLT_imm_chooser: std_logic_vector(2 downto 0) := "000";

    constant SLT_id_branch: std_logic := '0';

    constant SLT_ex: type_control_ex :=
    (
        branch_op => "000",
        rx_src => "000",
        ry_src => '0',
        reg_dst => "101",
        alu_op => "1000",
        branch => '0'
    );

    constant SLT_mem: type_control_mem :=
    (
        mem_read => '0',
        mem_write => '0'
    );

    constant SLT_wb: type_control_wb :=
    (
        mem_to_reg => '1',
        reg_write => '1'
    );

    constant CMP_imm_chooser: std_logic_vector(2 downto 0) := "000";

    constant CMP_id_branch: std_logic := '0';

    constant CMP_ex: type_control_ex :=
    (
        branch_op => "000",
        rx_src => "000",
        ry_src => '0',
        reg_dst => "101",
        alu_op => "0100",
        branch => '0'
    );

    constant CMP_mem: type_control_mem :=
    (
        mem_read => '0',
        mem_write => '0'
    );

    constant CMP_wb: type_control_wb :=
    (
        mem_to_reg => '1',
        reg_write => '1'
    );

    constant SLTU_imm_chooser: std_logic_vector(2 downto 0) := "000";

    constant SLTU_id_branch: std_logic := '0';

    constant SLTU_ex: type_control_ex :=
    (
        branch_op => "000",
        rx_src => "000",
        ry_src => '0',
        reg_dst => "101",
        alu_op => "0111",
        branch => '0'
    );

    constant SLTU_mem: type_control_mem :=
    (
        mem_read => '0',
        mem_write => '0'
    );

    constant SLTU_wb: type_control_wb :=
    (
        mem_to_reg => '1',
        reg_write => '1'
    );

    constant MFIH_imm_chooser: std_logic_vector(2 downto 0) := "000";

    constant MFIH_id_branch: std_logic := '0';

    constant MFIH_ex: type_control_ex :=
    (
        branch_op => "000",
        rx_src => "010",
        ry_src => '0',
        reg_dst => "000",
        alu_op => "1001",
        branch => '0'
    );

    constant MFIH_mem: type_control_mem :=
    (
        mem_read => '0',
        mem_write => '0'
    );

    constant MFIH_wb: type_control_wb :=
    (
        mem_to_reg => '1',
        reg_write => '1'
    );

    constant MTIH_imm_chooser: std_logic_vector(2 downto 0) := "000";

    constant MTIH_id_branch: std_logic := '0';

    constant MTIH_ex: type_control_ex :=
    (
        branch_op => "000",
        rx_src => "000",
        ry_src => '0',
        reg_dst => "100",
        alu_op => "1001",
        branch => '0'
    );

    constant MTIH_mem: type_control_mem :=
    (
        mem_read => '0',
        mem_write => '0'
    );

    constant MTIH_wb: type_control_wb :=
    (
        mem_to_reg => '1',
        reg_write => '1'
    );

end package constant_instruction;
