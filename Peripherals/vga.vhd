library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;

library std;
use std.textio.all;


use work.commonPak.all;
use work.utils.all;

entity VGA is
    GENERIC(
        textLength: INTEGER := 20;
        textHeight: INTEGER := 16;
        textSep: INTEGER := 8;
        startRow: INTEGER := 32;
        startCol: INTEGER := 32;
        indent: INTEGER := 8
    );
    PORT (
        clk, rst:  IN   STD_LOGIC;

        h_sync, v_sync    :  OUT  STD_LOGIC;  --horiztonal, vertical sync pulse
	    r, g, b : out STD_LOGIC_VECTOR(2 downto 0);

        register_file: in RegisterArray;

        flash_pin: in type_flash_pin;

        ps2_clk: in std_logic;
        ps2_data: in std_logic;
        instruction: in std_logic_vector(15 downto 0);
        pc: in std_logic_vector(15 downto 0)
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

    shared VARIABLE displayText: STRING (1 to textLength) := (others => NUL);
    shared VARIABLE top_left_corner: point_2d := (0, 0);

    SIGNAL displayTextSig: STRING (1 to textLength) := (others => NUL);
    SIGNAL top_left_corner_sig: point_2d := (0, 0);
    -- not in use
    SIGNAL disp_ena: STD_LOGIC;
    SIGNAL n_blank : STD_LOGIC;
    SIGNAL n_sync : STD_LOGIC;

    SIGNAL register_file_signal: RegisterArray;

    -- keyboard
    SIGNAL ascii_new: STD_LOGIC;
    SIGNAL ascii_code: STD_LOGIC_VECTOR(6 downto 0);

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

    register_file_signal <= register_file;

    select_text: process (clk)
    begin
        top_left_corner := (400, 300);
        displayText := "ORZ";
        if row < startRow + 1 * (textHeight + textSep) then
            top_left_corner := (startCol, startRow);
            displayText := "Registers";
        elsif row < startRow + 2 * (textHeight + textSep) then
            top_left_corner := (1 * indent + startCol, startRow + 1 * (textHeight + textSep));
            displayText := "R0 = 0x" & to_hex_string(register_file_signal(0));
        elsif row < startRow + 3 * (textHeight + textSep) then
            top_left_corner := (1 * indent + startCol, startRow + 2 * (textHeight + textSep));
            displayText := "R1 = 0x" & to_hex_string(register_file_signal(1));
        elsif row < startRow + 4 * (textHeight + textSep) then
            top_left_corner := (1 * indent + startCol, startRow + 3 * (textHeight + textSep));
            displayText := "R2 = 0x" & to_hex_string(register_file_signal(2));
        elsif row < startRow + 5 * (textHeight + textSep) then
            top_left_corner := (1 * indent + startCol, startRow + 4 * (textHeight + textSep));
            displayText := "R3 = 0x" & to_hex_string(register_file_signal(3));
        elsif row < startRow + 6 * (textHeight + textSep) then
            top_left_corner := (1 * indent + startCol, startRow + 5 * (textHeight + textSep));
            displayText := "R4 = 0x" & to_hex_string(register_file_signal(4));
        elsif row < startRow + 7 * (textHeight + textSep) then
            top_left_corner := (1 * indent + startCol, startRow + 6 * (textHeight + textSep));
            displayText := "R5 = 0x" & to_hex_string(register_file_signal(5));
        elsif row < startRow + 8 * (textHeight + textSep) then
            top_left_corner := (1 * indent + startCol, startRow + 7 * (textHeight + textSep));
            displayText := "R6 = 0x" & to_hex_string(register_file_signal(6));
        elsif row < startRow + 9 * (textHeight + textSep) then
            top_left_corner := (1 * indent + startCol, startRow + 8 * (textHeight + textSep));
            displayText := "R7 = 0x" & to_hex_string(register_file_signal(7));

        elsif row < startRow + 11 * (textHeight + textSep) then
            top_left_corner := (1 * indent + startCol, startRow + 10 * (textHeight + textSep));
            displayText := "PC = 0x" & to_hex_string(pc);
        elsif row < startRow + 12 * (textHeight + textSep) then
            top_left_corner := (1 * indent + startCol, startRow + 11 * (textHeight + textSep));
            displayText := "IN = 0x" & to_hex_string(instruction);

        elsif row < startRow + 15 * (textHeight + textSep) then
            top_left_corner := (1 * indent + startCol, startRow + 14 * (textHeight + textSep));
            if flash_pin.flash_addr(16 downto 1) = x"4000" then
                displayText := "Welcome";
            else
                displayText := "flash_addr = 0x" & to_hex_string(flash_pin.flash_addr(16 downto 1));
            end if;
        elsif row < startRow + 16 * (textHeight + textSep) then
            top_left_corner := (1 * indent + startCol, startRow + 15 * (textHeight + textSep));
            displayText := "Key = " & to_hex_string("000000000" & ascii_code);
        end if;
    end process;

    displayTextSig <= displayText;
    top_left_corner_sig <= top_left_corner;

    pixel_on: entity work.Pixel_On_Text
    generic map (
        textLength => textLength
    )
    port map(
        clk => clk,
        displayText => displayTextSig,

        position => top_left_corner_sig,

        horzCoord => column,
        vertCoord => row,

        pixel => pixel
    );

    keyboard: entity work.ps2_keyboard_to_ascii
    port map(
        clk => clk,
        ps2_clk => ps2_clk,
        ps2_data => ps2_data,
        ascii_new => ascii_new,
        ascii_code => ascii_code
    );

end beh;
