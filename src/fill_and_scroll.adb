with Addressable_LEDs; use Addressable_LEDs;
with Addressable_LEDs.neopixel_spi; use Addressable_LEDs.neopixel_spi;
with SPI_config; use SPI_config;
with LED_magic; use LED_magic;
with Ada.Real_Time; use Ada.Real_Time;

procedure fill_and_scroll is

    Strip_count : constant Positive := 5;
    Strip_mode : constant LED_Mode := GRB;
    Strip_1 : aliased LED_Strip_ws2812b_SPI := Create(Strip_mode, Strip_count, 8, Npxl_SPI'Access);

begin

    Initialize_NeoPixel;
    Set_Color(Strip_1, 0, (0, 125, 0, 0) );
    Set_Color(Strip_1, 1, (100, 100, 0, 0) );
    Set_Color(Strip_1, 2, (125, 0, 0, 0) );
    Set_Color(Strip_1, 3, (100, 0, 100, 0) );
    Set_Color(Strip_1, 4, (0, 0, 125, 0) );

    loop
        Strip_1.Show;
        Rotate_Buffer(Strip_1, 1);
        
        delay until Clock + Milliseconds(250);
    end loop;

end fill_and_scroll;
