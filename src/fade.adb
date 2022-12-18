with Addressable_LEDs; use Addressable_LEDs;
with Addressable_LEDs.neopixel_spi; use Addressable_LEDs.neopixel_spi;
with SPI_config; use SPI_config;
with LED_magic; use LED_magic;
with Ada.Real_Time; use Ada.Real_Time;


procedure Fade is

    Strip_count : constant Positive := 5;
    Strip_mode : constant LED_Mode := GRB;
    Strip_1 : aliased LED_Strip_ws2812b_SPI := Create(Strip_mode, Strip_count, 8, Npxl_SPI'Access);

    Color_1 : constant LED_values := (100, 100, 0, 0);
    Palette_1 : Color_Palette(0 .. 30);
    Loop_Index : Integer := Palette_1'First;
    Diff : Integer := 1;

begin

    Initialize_NeoPixel;
    Generate_Monochromatic_Gradient_Palette(Palette_1, Color_1, 101);

    infinite :
    loop

        Fill(Strip_1, Palette_1(Loop_Index) );
        Strip_1.Show;

        if (Loop_Index = Palette_1'Last) then
            Diff := -1;
        elsif (Loop_Index = Palette_1'First) then
            Diff := 1;
        end if;

        Loop_Index := Loop_Index + Diff;

        delay until Clock + Milliseconds(40);

    end loop infinite;

end Fade;
