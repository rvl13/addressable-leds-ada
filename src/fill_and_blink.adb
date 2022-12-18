with Addressable_LEDs; use Addressable_LEDs;
with Addressable_LEDs.neopixel_spi; use Addressable_LEDs.neopixel_spi;
with HAL; use HAL;
with HAL.SPI; --use HAL.SPI;
with SPI_config; use SPI_config;
with LED_magic; use LED_magic;
with Ada.Real_Time; use Ada.Real_Time;


procedure fill_and_blink is

    Strip_count : constant Positive := 5;
    Strip_mode : constant LED_Mode := GRB;
    Strip_1 : aliased LED_Strip_ws2812b_SPI := Create(Strip_mode, Strip_count, 8, Npxl_SPI'Access);

begin

    Initialize_NeoPixel;

    loop
        Fill(Strip_1, (100, 0, 180, 0) );
        Strip_1.Show;
        delay until Clock + Milliseconds(500);

        Fill(Strip_1, (0, 0, 0, 0) );
        Strip_1.Show;
        delay until Clock + Milliseconds(500);
    end loop;


end fill_and_blink;
