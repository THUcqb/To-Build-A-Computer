library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;

library std;
use std.textio.all;

use work.commonPak.all;
use work.utils.all;

entity VGA is
    PORT (
        clk, clk_50, rst: IN STD_LOGIC;

        control_mem: in type_control_mem;
        address, write_data: in std_logic_vector(15 downto 0);
        h_sync, v_sync: OUT STD_LOGIC;  --horiztonal, vertical sync pulse
	    r, g, b: out STD_LOGIC_VECTOR(2 downto 0)
	);
end VGA;

architecture beh of VGA is

    COMPONENT vga_controller
        GENERIC(
            h_pulse  :  INTEGER;   --horiztonal sync pulse width in pixels
            h_bp     :  INTEGER;   --horiztonal back porch width in pixels
            h_pixels :  INTEGER;  --horiztonal display width in pixels
            h_fp     :  INTEGER;   --horiztonal front porch width in pixels
            h_pol    :  STD_LOGIC;   --horizontal sync pulse polarity (1 = positive, 0 = negative)
            v_pulse  :  INTEGER;     --vertical sync pulse width in rows
            v_bp     :  INTEGER;    --vertical back porch width in rows
            v_pixels :  INTEGER;  --vertical display width in rows
            v_fp     :  INTEGER;     --vertical front porch width in rows
            v_pol    :  STD_LOGIC);  --vertical sync pulse polarity (1 = positive, 0 = negative)
        PORT(
            pixel_clk :  IN   STD_LOGIC;  --pixel clock at frequency of VGA mode being used
            reset_n   :  IN   STD_LOGIC;  --active low asycnchronous reset
            h_sync    :  OUT  STD_LOGIC;  --horiztonal sync pulse
            v_sync    :  OUT  STD_LOGIC;  --vertical sync pulse
            disp_ena  :  OUT  STD_LOGIC;  --display enable ('1' = display time, '0' = blanking time)
            column    :  OUT  INTEGER;    --horizontal pixel coordinate
            row       :  OUT  INTEGER;    --vertical pixel coordinate
            n_blank   :  OUT  STD_LOGIC;  --direct blacking output to DAC
            n_sync    :  OUT  STD_LOGIC); --sync-on-green output to DAC
    END component;

    -- Refreshing coordinates
    SIGNAL column : INTEGER;
    SIGNAL row : INTEGER;
    SIGNAL pixel: STD_LOGIC;

    -- video memory register file
    subtype t_dim0 is std_logic_vector(6 downto 0);
    type t_dim0_vector is array(natural range <>) of t_dim0;
    subtype t_dim1 is t_dim0_vector(0 to 79);
    type t_dim1_vector is array(natural range <>) of t_dim1;
    subtype t_dim2 is t_dim1_vector(0 to 3);
    signal video_memory: t_dim2 := (others => (others => (others => '0')));


    -- Text range to display and top_left_corner for the text
    signal displayAscii: std_logic_vector(6 downto 0);
    signal top_left_corner: point_2d := (0, 0);

    -- SIGNAL displayTextSig: STRING (1 to textLength) := (others => NUL);
    -- SIGNAL top_left_corner_sig: point_2d := (0, 0);
    -- not in use
    SIGNAL disp_ena: STD_LOGIC;
    SIGNAL n_blank : STD_LOGIC;
    SIGNAL n_sync : STD_LOGIC;
    shared variable target_row, target_col : integer := 0;

    SIGNAL cursor_twinkle: std_logic := '0';
    shared variable cursor_twinkle_cnt: integer := 0;

begin

	controller: vga_controller
    generic map (
        h_pulse => 120,   --horiztonal sync pulse width in pixels
        h_bp => 64,   --horiztonal back porch width in pixels
        h_pixels => 800,  --horiztonal display width in pixels
        h_fp=> 56,   --horiztonal front porch width in pixels
        h_pol=> '0',   --horizontal sync pulse polarity (1 = positive, 0 = negative)
        v_pulse => 6,     --vertical sync pulse width in rows
        v_bp => 23,    --vertical back porch width in rows
        v_pixels => 600,  --vertical display width in rows
        v_fp => 37,     --vertical front porch width in rows
        v_pol => '0'  --vertical sync pulse polarity (1 = positive, 0 = negative)
    )
    port map(
        pixel_clk=>clk_50,
        reset_n=>rst,

        column=>column,
        row=>row,

        h_sync=>h_sync,
        v_sync=>v_sync,

        -- not in use
        disp_ena=>disp_ena,
        n_blank=>n_blank,
        n_sync=>n_sync
    );

    pixel_on: entity work.Pixel_On_Text
    port map (
        clk => clk_50,
        displayAscii => displayAscii,

        position => top_left_corner,

        horzCoord => column,
        vertCoord => row,

        pixel => pixel
    );

    r <= (others => pixel);
    g <= (others => pixel);
    b <= (others => pixel);


    process (rst, clk)
        -- variable target_row, target_col : integer;
    begin
        if rst = '0' then
            video_memory <= (others => (others => (others => '0')));
        else
            if rising_edge(clk) then
                cursor_twinkle_cnt := cursor_twinkle_cnt + 1;
                if cursor_twinkle_cnt = 20_000_000 then
                    cursor_twinkle <= not cursor_twinkle;
                    cursor_twinkle_cnt := 0;
                end if;
            end if;

            if falling_edge(clk) and control_mem.mem_write = '1' then
                if write_data(6 downto 0) = "0001101" then -- Enter
                    target_row := target_row + 1;
                    target_col := 0;
                else
                    target_col := target_col + 1;
                    if target_col = 80 then
                        target_row := target_row + 1;
                        target_col := 0;
                    end if;
                    -- target_row := to_integer(Unsigned(address(15 downto 14)));
                    -- target_col := to_integer(Unsigned(address(13 downto 7)));
                    video_memory(target_row)
                                (target_col)
                                <= write_data(6 downto 0);
                end if;

            end if;
        end if;
    end process;

    select_text: process (clk_50)
    begin
        top_left_corner <= (((column / FONT_WIDTH) * FONT_WIDTH),
                            ((row / FONT_HEIGHT) * FONT_HEIGHT));

        if 0 <= row and row < 4 * FONT_HEIGHT and 0 <= column and column < 80 * FONT_WIDTH then
        displayAscii <= video_memory(row / FONT_HEIGHT)
                                    (column / FONT_WIDTH);
        else
            displayAscii <= "0000000";
        end if;

        if column / FONT_WIDTH = target_col and row / FONT_HEIGHT = target_row then
            if cursor_twinkle = '1' then
                displayAscii <= "0000000";
            else
                displayAscii <= "0001000";
            end if;
        end if;
    end process;

end beh;
