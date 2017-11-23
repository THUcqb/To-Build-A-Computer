library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_logic_ARITH.ALL;
use IEEE.std_logic_UNSIGNED.ALL;

entity ALU is
    port (
    -- IN
        input_x : in std_logic_vector (15 downto 0);
        input_y : in std_logic_vector (15 downto 0);
        op : in std_logic_vector (3 downto 0);
        
    -- OUT
        alu_result : out std_logic_vector (15 downto 0);
        --Carry Flag
        cf : out std_logic;
        --Zero Flag
        zf : out std_logic;
        --Signed Flag
        sf : out std_logic;
        --Overflow Flag
        vf : out std_logic
    );
end ALU;

architecture Behavorial of ALU is

    shared variable tmp_result : std_logic_vector (15 downto 0);
    
begin

    process (input_x, input_y, op)        
    begin

        case op is

            -- ADD: A + B
            when "0000" =>
                tmp_result := input_x + input_y;
                if (CONV_INTEGER(tmp_result) < CONV_INTEGER(input_x)) then
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
                if ((tmp_result(15) = '1') /= (input_x(15) = '1')) AND
                          ((input_x(15) = '1') = (input_y(15) = '1')) then
                    vf <= '1';
                else
                    vf <= '0';
                end if;

            -- SUB: A - B
            when "0001" =>
                tmp_result := input_x - input_y;
                if (CONV_INTEGER(input_x) < CONV_INTEGER(input_y)) then
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
                if ((tmp_result(15) = '1') /= (input_x(15) = '1')) AND
                          ((input_x(15) = '1') = (input_y(15) = '0')) then
                    vf <= '1';
                else
                    vf <= '0';
                end if;

            -- AND
            when "0010" =>
                tmp_result := input_x AND input_y;
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

            -- OR
            when "0011" =>
                tmp_result := input_x OR input_y;
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

            -- XOR
            when "0100" =>
                tmp_result := input_x XOR input_y;
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

            -- NOT A
            when "0101" =>
                tmp_result := NOT input_x;
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

            -- SLL: A << B
            when "0110" =>
                tmp_result := TO_STDLOGICVECTOR(TO_BITVECTOR(input_x) SLL CONV_INTEGER(input_y));
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

            -- SRL: A >> B
            when "0111" =>
                tmp_result := TO_STDLOGICVECTOR(TO_BITVECTOR(input_x) SRL CONV_INTEGER(input_y));
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

            -- SRA: A >> B
            when "1000" =>
                tmp_result := TO_STDLOGICVECTOR(TO_BITVECTOR(input_x) SRA CONV_INTEGER(input_y));
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

            -- ROL
            when "1001" =>
                tmp_result := TO_STDLOGICVECTOR(TO_BITVECTOR(input_x) ROL CONV_INTEGER(input_y));
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

            when others =>
                tmp_result := "0000000000000000";
                cf <= '0';
                zf <= '0';
                sf <= '0';
                vf <= '0';

        end case;
        alu_result <= tmp_result;
        
    end process;

end Behavorial;
