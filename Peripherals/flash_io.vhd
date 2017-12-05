----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    23:19:42 10/29/2011
-- Design Name:
-- Module Name:    flash_byte - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity flash_io is
    Port (
    addr : in  STD_LOGIC_VECTOR (22 downto 1);
    data_out : out  STD_LOGIC_VECTOR (15 downto 0);
    clk : in std_logic;
    reset : in std_logic;

    flash_byte : out std_logic;--BYTE#
    flash_vpen : out std_logic;
    flash_ce : out std_logic;
    flash_oe : out std_logic;
    flash_we : out std_logic;
    flash_rp : out std_logic;
    flash_addr : out std_logic_vector(22 downto 1);
    flash_data : in std_logic_vector(15 downto 0)

    );
end flash_io;

architecture Behavioral of flash_io is
    type flash_state is (
        waiting,
        read1, read2, read3, read4,
        done
    );
    signal state : flash_state := waiting;
    signal next_state : flash_state := waiting;

    begin

        flash_byte <= '1';
        flash_vpen <= '1';
        flash_ce <= '0';
        flash_rp <= '1';
        flash_we <= '1';

        process (clk, reset)
        begin
            if (reset = '0') then
                flash_oe <= '1';
                state <= waiting;
                next_state <= waiting;
                -- flash_data <= (others => 'Z');
            elsif (clk'event and clk = '1') then
                case state is
                    when waiting =>
                    -- if (ctl_read /= ctl_read_last) then
                        state <= read1;
                        -- ctl_read_last <= ctl_read;
                    -- else
                    -- end if;

                    when read1 =>
                    -- flash_data <= x"00FF";
                    state <= read2;
                    when read2 =>
                    state <= read3;
                    when read3 =>
                    flash_oe <= '0';
                    flash_addr <= addr;
                    -- flash_data <= (others => 'Z');
                    state <= read4;
                    when read4 =>
                    data_out <= flash_data;
                    state <= done;

                    when others =>
                    flash_oe <= '1';
                    -- flash_data <= (others => 'Z');
                    state <= waiting;
                end case;
            end if;
        end process;


    end Behavioral;
