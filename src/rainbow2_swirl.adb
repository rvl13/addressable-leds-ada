with Addressable_LEDs; use Addressable_LEDs;
with Addressable_LEDs.neopixel_spi; use Addressable_LEDs.neopixel_spi;
with SPI_config; use SPI_config;
with LED_magic; use LED_magic;
with Ada.Real_Time; use Ada.Real_Time;

procedure rainbow2_swirl is

    Strip_count : constant Positive := 5;
    Strip_mode : constant LED_Mode := GRB;
    Strip_1 : aliased LED_Strip_ws2812b_SPI := Create(Strip_mode, Strip_count, 8, Npxl_SPI'Access);

    Palette_1 : Color_Palette(0 .. 24);
    Loop_Index : Integer := 0;

begin

    Initialize_NeoPixel;
    Generate_Rainbow2_Palette(Palette_1);

    Infinite :
    loop
        Magic_Copy(Palette_1, Strip_1, Loop_Index);
        Strip_1.Show;
        Loop_Index := (Loop_Index - 1) mod (Palette_1'Length);

        delay until Clock + Milliseconds(50);
    end loop Infinite;

end rainbow2_swirl;
