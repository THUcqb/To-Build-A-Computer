----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:43:26 10/20/2017 
-- Design Name: 
-- Module Name:    ALU - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
    Port (
            inputA : in STD_LOGIC_VECTOR (15 downto 0);
            inputB : in STD_LOGIC_VECTOR (15 downto 0);
            op : in STD_LOGIC_VECTOR (3 downto 0); --4位操作码
            result : out STD_LOGIC_VECTOR (15 downto 0);
            cf : out STD_LOGIC; --Carry Flag 无符号进位标志位
            zf : out STD_LOGIC; --Zero Flag 零标志位
            sf : out STD_LOGIC; --Signed Flag 负数标志位
            vf : out STD_LOGIC --Overflow Flag 溢出标志位
         );
    end ALU;

architecture Behavorial of ALU is

    shared variable tmp_result : STD_LOGIC_VECTOR (15 downto 0);
    
begin

    process (inputA, inputB, op)        
    begin

        case op is

            when "0000" =>          --ADD: A + B
                tmp_result := inputA + inputB;
                if (CONV_INTEGER(tmp_result) < CONV_INTEGER(inputA)) then
                    cf <= '1';
                else
                    cf <= '0';
                end if;
                if (tmp_result = "0000000000000000") then
                    zf <= '1';
                else
                    zf <= '0';
                end if;
                if (tmp_result(15) = '1') then
                    sf <= '1';
                else
                    sf <= '0';
                end if;
                if ((tmp_result(15) = '1') /= (inputA(15) = '1')) AND
                          ((inputA(15) = '1') = (inputB(15) = '1')) then
                    vf <= '1';
                else
                    vf <= '0';
                end if;

            when "0001" =>          --SUB: A - B
                tmp_result := inputA - inputB;
                if (CONV_INTEGER(inputA) < CONV_INTEGER(inputB)) then --减法的无符号溢出是这么理解吗？
                    cf <= '1';
                else
                    cf <= '0';
                end if;
                if (tmp_result = "0000000000000000") then
                    zf <= '1';
                else
                    zf <= '0';
                end if;
                if (tmp_result(15) = '1') then
                    sf <= '1';
                else
                    sf <= '0';
                end if;
                if ((tmp_result(15) = '1') /= (inputA(15) = '1')) AND
                          ((inputA(15) = '1') = (inputB(15) = '0')) then
                    vf <= '1';
                else
                    vf <= '0';
                end if;

            when "0010" =>          --AND
                tmp_result := inputA AND inputB;
                if (tmp_result = "0000000000000000") then
                    zf <= '1';
                else
                    zf <= '0';
                end if;
                if (tmp_result(15) = '1') then
                    sf <= '1';
                else
                    sf <= '0';
                end if;
                cf <= '0';
                vf <= '0';

            when "0011" =>          --OR
                tmp_result := inputA OR inputB;
                if (tmp_result = "0000000000000000") then
                    zf <= '1';
                else
                    zf <= '0';
                end if;
                if (tmp_result(15) = '1') then
                    sf <= '1';
                else
                    sf <= '0';
                end if;
                cf <= '0';
                vf <= '0';

            when "0100" =>          --XOR
                tmp_result := inputA XOR inputB;
                if (tmp_result = "0000000000000000") then
                    zf <= '1';
                else
                    zf <= '0';
                end if;
                if (tmp_result(15) = '1') then
                    sf <= '1';
                else
                    sf <= '0';
                end if;
                cf <= '0';
                vf <= '0';

            when "0101" =>          --NOT A
                tmp_result := NOT inputA;
                if (tmp_result = "0000000000000000") then
                    zf <= '1';
                else
                    zf <= '0';
                end if;
                if (tmp_result(15) = '1') then
                    sf <= '1';
                else
                    sf <= '0';
                end if;
                cf <= '0';
                vf <= '0';

            when "0110" =>          --SLL: A << B
                tmp_result := TO_STDLOGICVECTOR(TO_BITVECTOR(inputA) SLL CONV_INTEGER(inputB));
                if (tmp_result = "0000000000000000") then
                    zf <= '1';
                else
                    zf <= '0';
                end if;
                if (tmp_result(15) = '1') then
                    sf <= '1';
                else
                    sf <= '0';
                end if;
                cf <= '0';
                vf <= '0';

            when "0111" =>          --SRL: A >> B 逻辑右移
                tmp_result := TO_STDLOGICVECTOR(TO_BITVECTOR(inputA) SRL CONV_INTEGER(inputB));
                if (tmp_result = "0000000000000000") then
                    zf <= '1';
                else
                    zf <= '0';
                end if;
                if (tmp_result(15) = '1') then
                    sf <= '1';
                else
                    sf <= '0';
                end if;
                cf <= '0';
                vf <= '0';

            when "1000" =>          --SRA: A >> B 算术右移
                tmp_result := TO_STDLOGICVECTOR(TO_BITVECTOR(inputA) SRA CONV_INTEGER(inputB));
                if (tmp_result = "0000000000000000") then
                    zf <= '1';
                else
                    zf <= '0';
                end if;
                if (tmp_result(15) = '1') then
                    sf <= '1';
                else
                    sf <= '0';
                end if;
                cf <= '0';
                vf <= '0';

            when "1001" =>          --ROL: 循环左移
                tmp_result := TO_STDLOGICVECTOR(TO_BITVECTOR(inputA) ROL CONV_INTEGER(inputB));
                if (tmp_result = "0000000000000000") then
                    zf <= '1';
                else
                    zf <= '0';
                end if;
                if (tmp_result(15) = '1') then
                    sf <= '1';
                else
                    sf <= '0';
                end if;
                cf <= '0';
                vf <= '0';

            when others =>          --其他情况
                tmp_result := "0000000000000000";
                cf <= '0';
                zf <= '0';
                sf <= '0';
                vf <= '0';

        end case;
        result <= tmp_result;
        
    end process;

end Behavorial;