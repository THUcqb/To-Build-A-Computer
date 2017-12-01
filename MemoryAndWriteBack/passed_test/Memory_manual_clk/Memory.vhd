library ieee;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.utils.all;

-- This is the implemetation of Memory
-- Can be both data memory and instruction memory

entity Memory is
    port(
    -- IN
        clk, rst: in std_logic;
        control_mem: in type_control_mem;
        address, write_data: in std_logic_vector(15 downto 0);

    -- OUT
        pin: out type_ram_pin;
        data: inout std_logic_vector(15 downto 0);

    -- debug
        dyp: out std_logic_vector(0 to 6)
    );
end Memory;

architecture memory_bev of Memory is

    signal state: type_mem_state := mem_st1;

begin

    --  Disable when resetting
    pin.en <= '1' when rst = '0' else
              '0';
    --  Disable when writing
    pin.oe <= '1' when rst = '0' else
              '0' when control_mem.mem_write = '0' else
              '1';
    --  Enable only when in writing state 2 (unless resetting)
    pin.we <= '1' when rst = '0' else
              '0' when control_mem.mem_write = '1' and state = mem_st2 else
              '1';

    pin.address <= "00" & address;
    --  Set to Z when preparing read.
    data <= write_data when control_mem.mem_write = '1' else
            (others => 'Z');

    process (clk, rst)
    begin
        if (rst = '0') then
            state <= mem_st1;
        elsif (rising_edge(clk)) then
            case state is
                when mem_st1 =>
                    state <= mem_st2;

                when mem_st2 =>
                    state <= mem_st1;

                when others =>

            end case;
        end if;
    end process;

    dyp <= "0110000" when state = mem_st1 else
           "1101101" when state = mem_st2;

end memory_bev;
