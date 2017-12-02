library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.DEFINES.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Memory is
    port (
        clk_in : in std_logic;
        rst : in std_logic;
        memSig : in std_logic_vector(1 downto 0);
        pc : in std_logic_vector(15 downto 0);
        inputAddr : in std_logic_vector(15 downto 0);
        inputData : in std_logic_vector(15 downto 0);

        boot_switch : in std_logic;

        clk_out : out std_logic;

        Cnfl : out std_logic;
        ifData : out std_logic_vector(15 downto 0);
        outputData : out std_logic_vector(15 downto 0);
        
        OE_I : out std_logic;
        WE_I : out std_logic;
        EN_I : out std_logic;

        InstMemBus : inout std_logic_vector(15 downto 0);
        InstMemAddr : out std_logic_vector(17 downto 0);

        OE_D : out std_logic;
        WE_D : out std_logic;
        EN_D : out std_logic;
        
        DataMemBus : inout std_logic_vector(15 downto 0);
        DataMemAddr : out std_logic_vector(17 downto 0);

        data_ready : in  STD_LOGIC;
        tbre : in  STD_LOGIC;
        tsre : in  STD_LOGIC;
        rdn : out  STD_LOGIC;
        wrn : out  STD_LOGIC;

        FlashByte : out std_logic;
        FlashVpen : out std_logic;
        FlashCE : out std_logic;
        FlashOE : out std_logic;
        FlashWE : out std_logic;
        FlashRP : out std_logic;
        FlashAddr : out std_logic_vector(22 downto 0);
        FlashDataBus : inout std_logic_vector(15 downto 0)
        );
end Memory;

architecture Behavioral of Memory is
    component FlashAdapter
        port (
            clk : in std_logic;
            rst : in std_logic;
            addr : in std_logic_vector(22 downto 0);
            data : out std_logic_vector(15 downto 0);
            ctrl_read : in std_logic;

            FlashByte : out std_logic;
            FlashVpen : out std_logic;
            FlashCE : out std_logic;
            FlashOE : out std_logic;
            FlashWE : out std_logic;
            FlashRP : out std_logic;

            FlashAddr : out std_logic_vector(22 downto 0);
            FlashDataBus : inout std_logic_vector(15 downto 0)
        );
    end component;
    signal FlashBootMemAddr : std_logic_vector(15 downto 0) := (others => '0');
    signal FlashBootAddr : std_logic_vector(22 downto 0) := (others => '0');

    signal FlashAddrInput : std_logic_vector(22 downto 0) := (others => '0');
    signal FlashDataOutput : std_logic_vector(15 downto 0) := (others => '0');

    signal FlashReadData : std_logic_vector(15 downto 0) := (others => '0');
    signal init_read : std_logic;

    signal FlashInnerTimer : integer := 0;


    type MemState is (flash_start, flash_read, flash_mem_write, flash_finish,
                      mem_st1, mem_st2);
    signal state : MemState := mem_st1;
    signal data_buffer : std_logic_vector(15 downto 0);

begin
    FlashAdapter_c : FlashAdapter port map (
        clk => clk_in,
        rst => rst,
        addr => FlashAddrInput,
        data => FlashDataOutput,
        ctrl_read => init_read,

        FlashByte => FlashByte,
        FlashVpen => FlashVpen,
        FlashCE => FlashCE,
        FlashOE => FlashOE,
        FlashWE => FlashWE,
        FlashRP => FlashRP,

        FlashAddr => FlashAddr,
        FlashDataBus => FlashDataBus
    );

    EN_I <= '1' when (rst = '0') else '0';
    OE_I <= '1' when (rst = '0' or (inputAddr(15) = '0' and memSig = MEM_WRITE)) else '0';
    WE_I <= '1' when (rst = '0' or not(inputAddr(15) = '0' and memSig = MEM_WRITE and state = mem_st2)) else '0';

    InstMemAddr <=  "00" & inputAddr when (inputAddr(15) = '0' and (memSig = MEM_READ or memSig = MEM_WRITE)) else "00" & pc;
    InstMemBus  <=  inputData when (rst = '1' and inputAddr(15) = '0' and memSig = MEM_WRITE) else
                    (others => 'Z');

    EN_D <= '1' when (rst = '0' or ((inputAddr = x"BF00" or inputAddr = x"BF01") and (memSig = MEM_READ or memSig = MEM_WRITE))) else '0';
    OE_D <= '1' when (rst = '0' or (inputAddr(15) = '1' and memSig = MEM_WRITE)) else '0';
    WE_D <= '0' when (rst = '1' and ((inputAddr(15) = '1' and memSig = MEM_WRITE and state = mem_st2) or (state = flash_mem_write))) else '1';

    DataMemAddr <=  "00" & FlashBootMemAddr when (state = flash_read or state = flash_mem_write) else
                    "00" & inputAddr;
    DataMemBus <= FlashReadData when (state = flash_read or state = flash_mem_write) else
                  data_buffer;

    Cnfl <= '1' when (rst = '1' and inputAddr(15) = '0' and (memSig = MEM_READ or memSig = MEM_WRITE)) else '0';

    ifData <= x"0800" when (rst = '1' and inputAddr(15) = '0' and (memSig = MEM_READ or memSig = MEM_WRITE)) else InstMemBus;
    outputData <= InstMemBus when (inputAddr(15) = '0') else 
                  ("00000000000000" & data_ready & (tsre and tbre)) when (inputAddr = x"BF01") else
                  DataMemBus;

    rdn <= not(memSig(0)) when (inputAddr = x"BF00" and state = mem_st2) else '1';
    wrn <= not(memSig(1)) when (inputAddr = x"BF00" and state = mem_st2) else '1';

    clk_out <= '0' when (state = mem_st2) else '1';



    p1: process(clk_in, rst)
    begin
        if(rst = '0') then
            if(boot_switch = '1') then
                state <= flash_start;
            else 
                state <= mem_st1;
            end if;
        elsif (clk_in'event and clk_in = '1') then
            case state is
            when flash_start =>
                FlashBootMemAddr <= (others => '0');
                FlashBootAddr <= (others => '0');
                FlashInnerTimer <= 0;

                init_read <= '1';
                state <= flash_read;
            when flash_read =>
                init_read <= '0';
                if(FlashInnerTimer < 6) then
                    FlashInnerTimer <= FlashInnerTimer + 1;
                    FlashAddrInput <= FlashBootAddr;
                    state <= flash_read;
                else 
                    -- FlashInnerTimer := FlashInnerTimer + 1;
                    FlashReadData <= FlashDataOutput;
                    FlashInnerTimer <= 0;
                    state <= flash_mem_write;
                end if;
            when flash_mem_write =>
                init_read <= '1';

                if(FlashBootMemAddr < x"0600") then
                    FlashBootMemAddr <= FlashBootMemAddr + 1;
                    FlashBootAddr <= FlashBootAddr + 2;
                    state <= flash_read;
                else 
                    state <= flash_finish;
                end if;
            when flash_finish =>
                state <= mem_st1;


            when mem_st1 =>
                if(memSig = MEM_WRITE and inputAddr(15) = '1') then
                    data_buffer <= inputData;
                else
                    data_buffer <= (others => 'Z');
                end if;
                state <= mem_st2;
            when mem_st2 =>
                if(memSig = MEM_WRITE and inputAddr(15) = '1') then 
                    data_buffer <= inputData;
                elsif(memSig /= MEM_READ or inputAddr /= x"BF00") then
                    data_buffer <= (others => 'Z');
                end if;
                state <= mem_st1;
            when others => 
                if(memSig = MEM_WRITE) then
                    data_buffer <= inputData;
                else
                    data_buffer <= (others => 'Z');
                end if;
            end case;
        end if;
    end process p1;
end Behavioral;