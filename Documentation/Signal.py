import pandas as pd
import math

df = pd.read_excel("Signals.xlsx")
df.head()

f = open("ConstantInstruction.vhd", "w")

out = """\
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.utils.all;

package constant_instruction is
""";

for i in range(1, 31):
    s = [];
    s.append(df["指令"][i]);
    for j in range(21, 33):
        tmp = df[df.columns[j]][i];
        if type(tmp) is float and math.isnan(tmp):
            tmp = df[df.columns[j]][31]
        s.append(tmp)
    out = out +\
    """\
    constant %s_imm_chooser: std_logic_vector(2 downto 0) := "%s";

    constant %s_id_branch: std_logic := '%s';

    constant %s_ex: type_control_ex :=
    (
        branch_op => "%s",
        rx_src => "%s",
        ry_src => '%s',
        reg_dst => "%s",
        alu_op => "%s",
        branch => '%s'
    );

    constant %s_mem: type_control_mem :=
    (
        mem_read => '%s',
        mem_write => '%s'
    );

    constant %s_wb: type_control_wb :=
    (
        mem_to_reg => '%s',
        reg_write => '%s'
    );

""" % (s[0], s[1], s[0], s[2], s[0], s[3], s[4], s[5], s[6], s[7], s[8], s[0], s[9], s[10], s[0], s[11], s[12]);

out = out + """\
end package constant_instruction;
"""

f.write(out)