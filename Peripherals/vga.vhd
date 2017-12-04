library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.commonPak.all;

entity VGA is
    GENERIC(
        textLength: INTEGER := 11
    );
    PORT (
        clk, rst:  IN   STD_LOGIC;

        h_sync, v_sync    :  OUT  STD_LOGIC;  --horiztonal, vertical sync pulse
	    r, g, b : out STD_LOGIC_VECTOR(2 downto 0)
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

    SIGNAL column : INTEGER;
    SIGNAL row : INTEGER;
    SIGNAL pixel: STD_LOGIC;

    SIGNAL displayText: STRING (1 to textLength) := (others => NUL);
    SIGNAL top_left_corner: point_2d := (0, 0);
    SIGNAL h_coord, v_coord: INTEGER;

    -- not in use
    SIGNAL disp_ena: STD_LOGIC;
    SIGNAL n_blank : STD_LOGIC;
    SIGNAL n_sync : STD_LOGIC; 


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
        pixel_clk=>clk, 
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

    r <= (others => pixel);
    g <= (others => pixel);
    b <= (others => pixel);

    -- For test
    displayText <= "Hello VGA  ";
    top_left_corner <= (0, 0);
    h_coord <= column;
    v_coord <= row;

    pixel_on: entity work.Pixel_On_Text
    port map(
        clk => clk,
        displayText => displayText,

        position => top_left_corner,

        horzCoord => h_coord,
        vertCoord => v_coord,

        pixel => pixel
    );
    
end beh;

