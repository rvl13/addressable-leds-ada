with Addressable_LEDs; use Addressable_LEDs;
with Addressable_LEDs.neopixel_spi; use Addressable_LEDs.neopixel_spi;
with SPI_config; use SPI_config;
with LED_magic; use LED_magic;
with Ada.Real_Time; use Ada.Real_Time;

procedure monochrome_scroll is

    Strip_count : constant Positive := 5;
    Strip_mode : constant LED_Mode := GRB;
    Strip_1 : aliased LED_Strip_ws2812b_SPI := Create(Strip_mode, Strip_count, 8, Npxl_SPI'Access);

    Color_1 : constant LED_values := (156, 0, 103, 0);
    Palette_1 : Color_Palette(0 .. Strip_count - 1);
    loop_index : Integer := 0;

begin

    Initialize_NeoPixel;
    Generate_Monochromatic_Gradient_Palette(Palette_1, Color_1, 5);

    loop
        Magic_Copy(Palette_1, Strip_1, loop_index);
        Strip_1.Show;
        loop_index := (loop_index + 1) mod Strip_count;
        delay until Clock + Milliseconds(100);
    end loop;

end monochrome_scroll;
