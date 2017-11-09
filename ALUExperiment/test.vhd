--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:11:44 10/20/2017
-- Design Name:   
-- Module Name:   D:/vhdlprograms/ALUExperiment/test.vhd
-- Project Name:  ALUExperiment
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ALUExperiment
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY test IS
END test;
 
ARCHITECTURE behavior OF test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ALUExperiment
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         inputSW : IN  std_logic_vector(15 downto 0);
         led : OUT  std_logic_vector(15 downto 0);
         sevenLight1 : OUT  std_logic_vector(6 downto 0);
         sevenLight2 : OUT  std_logic_vector(6 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal inputSW : std_logic_vector(15 downto 0) := (others => '0');

 	--Outputs
   signal led : std_logic_vector(15 downto 0);
   signal sevenLight1 : std_logic_vector(6 downto 0);
   signal sevenLight2 : std_logic_vector(6 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ALUExperiment PORT MAP (
          clk => clk,
          rst => rst,
          inputSW => inputSW,
          led => led,
          sevenLight1 => sevenLight1,
          sevenLight2 => sevenLight2
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period / 2;
		clk <= '1';
		wait for clk_period / 2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.	
      rst <= '1';
      inputSW <= "0000000000000001";
      wait for clk_period;
      inputSW <= "0000000000000010";
      wait for clk_period;
      inputSW <= "0000000000000000";
      wait for clk_period;
      inputSW <= "0000000000000000";
      wait for clk_period;
      inputSW <= "0000000000000000";
      wait for clk_period;
      
      inputSW <= "0000000000000001";
      wait for clk_period;
      inputSW <= "0000000000000010";
      wait for clk_period;
      inputSW <= "0000000000000001";
      wait for clk_period;
      inputSW <= "0000000000000000";
      wait for clk_period;
      inputSW <= "0000000000000000";
      wait for clk_period;
      wait;
      -- insert stimulus here 

   end process;

END;
