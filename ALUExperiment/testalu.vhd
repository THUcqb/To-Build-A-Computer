--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:44:16 10/20/2017
-- Design Name:   
-- Module Name:   D:/vhdlprograms/ALUExperiment/testalu.vhd
-- Project Name:  ALUExperiment
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ALU
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
 
ENTITY testalu IS
END testalu;
 
ARCHITECTURE behavior OF testalu IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ALU
    PORT(
         inputA : IN  std_logic_vector(15 downto 0);
         inputB : IN  std_logic_vector(15 downto 0);
         op : IN  std_logic_vector(3 downto 0);
         result : OUT  std_logic_vector(15 downto 0);
         cf : OUT  std_logic;
         zf : OUT  std_logic;
         sf : OUT  std_logic;
         vf : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal inputA : std_logic_vector(15 downto 0) := (others => '0');
   signal inputB : std_logic_vector(15 downto 0) := (others => '0');
   signal op : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal result : std_logic_vector(15 downto 0);
   signal cf : std_logic;
   signal zf : std_logic;
   signal sf : std_logic;
   signal vf : std_logic;
  
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ALU PORT MAP (
          inputA => inputA,
          inputB => inputB,
          op => op,
          result => result,
          cf => cf,
          zf => zf,
          sf => sf,
          vf => vf
        );

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
      
      inputA <= "0000000000000001";
      inputB <= "0000000000000010";
      op <= "0000";
      
      wait;
   end process;

END;
