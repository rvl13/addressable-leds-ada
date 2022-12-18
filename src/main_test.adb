with Addressable_LEDs; use Addressable_LEDs;
with Addressable_LEDs.neopixel_spi; use Addressable_LEDs.neopixel_spi;
with SPI_config; use SPI_config;
with Ada.Real_Time; use Ada.Real_Time;

procedure main_test is

    Strip_count : constant Positive := 5;
    Strip_mode : constant LED_Mode := GRB;
    Strip_1 : aliased LED_Strip_ws2812b_SPI := Create(Strip_mode, Strip_count, 8, Npxl_SPI'Access);

    procedure All_Off(Strip : out LED_Strip_ws2812b_SPI);

    procedure All_On(Strip : out LED_Strip_ws2812b_SPI);

    procedure All_Off(Strip : out LED_Strip_ws2812b_SPI) is
    begin
        for i in Natural range 0 .. (Strip.Get_Count - 1) loop
            Strip.Set_Color(i, Black);
        end loop;
    end All_Off;

    procedure All_On(Strip : out LED_Strip_ws2812b_SPI) is
    begin
        for i in Natural range 0 .. (Strip.Get_Count - 1) loop
            Strip.Set_Color(i, (100, 100, 100, 0));
        end loop;
    end All_On;

begin

    Initialize_NeoPixel;

    Set_Color(Strip_1, 0, (125, 0, 0, 0) );
    Set_Color(Strip_1, 1, (0, 110, 0, 0) );
    Strip_1.Set_Color(2, (100, 0, 115, 0));
    Strip_1.Set_Color(3, (0, 0, 80, 0));

    Strip_1.Set_Color(4, Strip_1.Get_Color(2));
   
    delay until Clock + Milliseconds(2000);
    Strip_1.Show;
    delay until Clock + Milliseconds(2000);

   loop
        All_Off(Strip_1);
        Strip_1.Show;
        delay until Clock + Milliseconds(500);

        All_On(Strip_1);
        Strip_1.Show;
        delay until Clock + Milliseconds(500);
   end loop;
   
   
end main_test;
