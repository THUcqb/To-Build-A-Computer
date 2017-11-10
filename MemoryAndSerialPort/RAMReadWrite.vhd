library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity RAMReadWrite is

    port(
        --  clock and reset
        clk, rst: in std_logic;
        ram1Begin: in std_logic;
        ram1Started, ram1End: out std_logic;
        --  switch
        sw: in std_logic_vector(15 downto 0);
        --  RAM control signal
        ram1Addr: out std_logic_vector(17 downto 0);
        ram1Data: inout std_logic_vector(15 downto 0);
        ram1OE, ram1WE, ram1EN: out std_logic;
        --  Showing current state for debugging use.
        dyp: out std_logic_vector(0 to 6)
    );

end RAMReadWrite;

architecture RAMReadWrite_beh of RAMReadWrite is

    signal tmpAddr: std_logic_vector(17 downto 0);
    signal tmpData: std_logic_vector(15 downto 0);
    shared variable cnt : Integer := 0;

    type state is (
        loadingAddr, loadingData,
        writingPrepare, writingExec, writingComplete,
        readingPrepare, readingExec, readingComplete
        );
    signal currentState: state;

begin

    process(clk, rst)
    begin
        -- Resest
        if (rst = '0') then

            ram1Addr <= (Others => '0');
            ram1Data <= (Others => 'Z');
            ram1OE <= '1';
            ram1WE <= '1';
            ram1EN <= '1';
            ram1Started <= '0';
            ram1End <= '0';

            currentState <= loadingAddr;

        -- Clicked
        elsif (clk'event and clk = '1') then
            case currentState is

            --  Loading from sw
                --  Load address
                when loadingAddr =>
                    if (ram1Begin = '1') then
                        ram1End <= '0';
                        ram1Started <= '1';
                        cnt := 0;
                        tmpAddr(15 downto 0) <= sw;

                        currentState <= loadingData;
                     end if;

                --  Load data
                when loadingData =>
                    tmpData <= ram1Data;

                    ram1EN <= '0';

                    currentState <= writingPrepare;

            --  Write tmpData to RAM1[tmpAddr]
                --  Writing stage 1:
                --  prepare and show the address and data.
                when writingPrepare =>

                    ram1Addr <= tmpAddr;
                    ram1Data <= tmpData;
                    ram1WE <= '1';

                    currentState <= writingExec;

                --  Writing stage 2:
                --  Pull down WE to write into the RAM.
                when writingExec =>
                    ram1WE <= '0';

                    currentState <= writingComplete;

                --  Writing stage 3:
                --  Push up WE to finish writing.
                --  And decide to continue writing or to start reading.
                when writingComplete =>
                    ram1WE <= '1';

                    cnt := cnt + 1;
                    tmpAddr <= tmpAddr + 1;
                    tmpData <= tmpData + 1;
                    if (cnt < 10) then
                        currentState <= writingPrepare;
                    else
                        currentState <= readingPrepare;
                    end if;

            --  Read from RAM1[tmpAddr] to tmpData
                --  Reading stage 1:
                --  clear the display
                --  Set the ram1Data to High impedance state
                when readingPrepare =>

                    cnt := cnt - 1;
                    tmpAddr <= tmpAddr - 1;

                    ram1Data <= (others => 'Z');

                    currentState <= readingExec;

                --  Reading stage 2:
                --  Show the address to read
                when readingExec =>
                    ram1OE <= '0';
                    ram1Addr <= tmpAddr;

                    currentState <= readingComplete;

                --  Reading stage 3:
                --  Read data out and display
                when readingComplete =>

                    if (cnt = 0) then      --  Already the base addr
                        ram1End <= '1';
                        ram1Started <= '0';
                        currentState <= loadingAddr;
                        ram1OE <= '1';
                    else
                        currentState <= readingPrepare;
                    end if;
                when others =>
            end case;
        end if;
    end process;

    --  LED Seven-Segment digital tube showing state information
    with currentState select
        dyp <= "0000000" when loadingAddr,
               "1000000" when loadingData,
               "0100000" when writingPrepare,
               "0010000" when writingExec,
               "0001000" when writingComplete,
               "0000100" when readingPrepare,
               "0000010" when readingExec,
               "0000001" when readingComplete,
               "1111111" when others;

end RAMReadWrite_beh;
