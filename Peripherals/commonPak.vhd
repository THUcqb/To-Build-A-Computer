--  Original Source from FP-V-GA-Text: https://github.com/MadLittleMods/FP-V-GA-Text
--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;

use ieee.math_real.all;

package commonPak is
	
	
	
	constant ADDR_WIDTH : integer := 11;
	constant DATA_WIDTH : integer := 8;
	
	constant FONT_WIDTH : integer := 8;
	constant FONT_HEIGHT : integer := 16;
	
	
------------------------------------------
	
	type point_2d is
	record
		x : integer;
		y : integer;
	end record;

	type type_textColorMap is array(natural range <>) of std_logic_vector(7 downto 0); 
	

------------------------------------------

	
	type type_drawElement is
	record
		pixelOn: boolean;
		rgb: std_logic_vector(7 downto 0);
	end record;
	constant init_type_drawElement: type_drawElement := (pixelOn => false, rgb => (others => '0'));
	type type_drawElementArray is array(natural range <>) of type_drawElement; 
	


------------------------------------------

	type type_inArbiterPort is
	record
		dataRequest: boolean;
		addr: std_logic_vector(ADDR_WIDTH-1 downto 0);
		writeRequest: boolean;
		writeData: std_logic_vector(DATA_WIDTH-1 downto 0);
	end record;
	constant init_type_inArbiterPort: type_inArbiterPort := (dataRequest => false, addr => (others => '0'), writeRequest => false, writeData  => (others => '0'));
	type type_inArbiterPortArray is array(natural range <>) of type_inArbiterPort;
	
	
	type type_outArbiterPort is
	record
		dataWaiting: boolean;
		data: std_logic_vector(DATA_WIDTH-1 downto 0);
		dataWritten: boolean;
	end record;
	constant init_type_outArbiterPort: type_outArbiterPort := (dataWaiting => false, data => (others => '0'), dataWritten => false);
	type type_outArbiterPortArray is array(natural range <>) of type_outArbiterPort;


----------------------

	function log2_float(val : positive) return natural;

    function to_hex_string(s: in std_logic_vector) return string;

end commonPak;

package body commonPak is
	function log2_float(val : positive) return natural is
	begin
		return integer(ceil(log2(real(val))));
	end function;

    function to_hex_string(s: in std_logic_vector) 
    return string 
    is 
        --- Locals to make the indexing easier 
        --constant s_norm: std_logic_vector(4 to s'length+3) := s; 
        variable result: string (1 to s'length/4); 
        --- A subtype to keep the VHDL compiler happy 
        --- (the rules about data types in a CASE are quite strict) 
        subtype slv4 is std_logic_vector(1 to 4); 
    begin 
        assert (s'length mod 4) = 0 
        report "SLV must be a multiple of 4 bits" 
        severity FAILURE; 

        for i in result'range loop 
            case slv4'(s((i-1)*4+3 downto (i-1)*4)) is 
                when "0000" => result(s'length/4 - i + 1) := '0'; 
                when "0001" => result(s'length/4 - i + 1) := '1'; 
                when "0010" => result(s'length/4 - i + 1) := '2'; 
                when "0011" => result(s'length/4 - i + 1) := '3'; 
                when "0100" => result(s'length/4 - i + 1) := '4'; 
                when "0101" => result(s'length/4 - i + 1) := '5'; 
                when "0110" => result(s'length/4 - i + 1) := '6'; 
                when "0111" => result(s'length/4 - i + 1) := '7'; 
                when "1000" => result(s'length/4 - i + 1) := '8'; 
                when "1001" => result(s'length/4 - i + 1) := '9'; 
                when "1010" => result(s'length/4 - i + 1) := 'A'; 
                when "1011" => result(s'length/4 - i + 1) := 'B'; 
                when "1100" => result(s'length/4 - i + 1) := 'C'; 
                when "1101" => result(s'length/4 - i + 1) := 'D'; 
                when "1110" => result(s'length/4 - i + 1) := 'E'; 
                when "1111" => result(s'length/4 - i + 1) := 'F'; 
                when others => result(s'length/4 - i + 1) := 'x';
            end case; 
        end loop; 
        return result; 
    end; 
end commonPak;
