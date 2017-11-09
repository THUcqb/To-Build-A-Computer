----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:41:51 10/20/2017 
-- Design Name: 
-- Module Name:    ALUExperiment - Behavioral 
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
library ieee;
use ieee.std_logic_1164.all;

entity ALUExperiment is
    port
    (
        clk: in std_logic;
        rst: in std_logic;
        inputSW: in std_logic_vector(15 downto 0);
        led: out std_logic_vector(15 downto 0);
        sevenLight1: out std_logic_vector(6 downto 0);
        sevenLight2: out std_logic_vector(6 downto 0)
    );
end ALUExperiment;

architecture ALUExperiment_bhv of ALUExperiment is
    component ALU is
        port
        (
            inputA: in std_logic_vector(15 downto 0);
            inputB: in std_logic_vector(15 downto 0);
            op: in std_logic_vector(3 downto 0);
            cf: out std_logic;
            zf: out std_logic;
            sf: out std_logic;
            vf: out std_logic;
            result: out std_logic_vector(15 downto 0)
        );
    end component;

    signal op: std_logic_vector(3 downto 0);
    signal inputA: std_logic_vector(15 downto 0);
    signal inputB: std_logic_vector(15 downto 0);
    signal cf: std_logic;
    signal zf: std_logic;
    signal sf: std_logic;
    signal vf: std_logic;
    signal result: std_logic_vector(15 downto 0);

    type state is (s0, s1, s2, s3, s4);
    signal current_state: state := s0;

begin
    aluu: ALU port map
    (
        inputA => inputA, inputB => inputB, op => op,
        cf => cf, zf => zf, sf => sf, vf => vf,
        result => result
    );

    process (clk, rst)
    begin
        if rst = '0' then
            current_state <= s0;
            inputA <= "0000000000000000";
            inputB <= "0000000000000000";
            led <= "0000000000000000";
            op <= "1111";
        elsif clk'event and clk = '1' then
            case current_state is
                when s0 =>
                    op <= "1111";
                    inputA <= inputSW;
                    led <= inputSW;

                when s1 =>
                    inputB <= inputSW;
                    led <= inputSW;

                when s2 =>
                    op <= inputSW(3 downto 0);
                    led <= "000000000000" & inputSW(3 downto 0);

                when s3 =>
                    led <= result;

                when s4 =>
                    led <= "000000000000" & cf & zf & sf & vf;

                when others =>
                    inputA <= "0000000000000000";
                    inputB <= "0000000000000000";
                    led <= "0000000000000000";
                    op <= "1111";

            end case;

            case current_state is
                when s0 => current_state <= s1;
                when s1 => current_state <= s2;
                when s2 => current_state <= s3;
                when s3 => current_state <= s4;
                when s4 => current_state <= s0;
                when others => current_state <= s0;
            end case;
        end if;
    end process;

    process(current_state)
    begin
        case current_state is
            when s0 =>
                sevenLight1 <= "1111110";
            when s1 =>
                sevenLight1 <= "0110000";
            when s2 =>
                sevenLight1 <= "1101101";
            when s3 =>
                sevenLight1 <= "1111001";
            when s4 =>
                sevenLight1 <= "0110011";
            when others =>
                sevenLight1 <= "0000000";
        end case;
    end process;

    process(op)
    begin
        case op is
            when "0000" =>
                sevenLight2 <= "1111110";
            when "0001" =>
                sevenLight2 <= "0110000";
            when "0010" =>
                sevenLight2 <= "1101101";
            when "0011" =>
                sevenLight2 <= "1111001";
            when "0100" =>
                sevenLight2 <= "0110011";
            when "0101" =>
                sevenLight2 <= "1011011";
            when "0110" =>
                sevenLight2 <= "1111101";
            when "0111" =>
                sevenLight2 <= "0000111";
            when "1000" =>
                sevenLight2 <= "1111111";
            when "1001" =>
                sevenLight2 <= "1101111";
            when others =>
                sevenLight2 <= "0000000";
        end case;
    end process;

end ALUExperiment_bhv;
