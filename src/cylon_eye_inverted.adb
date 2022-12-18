with Addressable_LEDs; use Addressable_LEDs;
with Addressable_LEDs.neopixel_spi; use Addressable_LEDs.neopixel_spi;
with SPI_config; use SPI_config;
with LED_magic; use LED_magic;
with Ada.Real_Time; use Ada.Real_Time;

procedure cylon_eye_inverted is

    Strip_count : constant Positive := 5;
    Strip_mode : constant LED_Mode := GRB;
    Strip_1 : aliased LED_Strip_ws2812b_SPI := Create(Strip_mode, Strip_count, 8, Npxl_SPI'Access);

    Color_1 : constant LED_values := (20, 0, 50, 0);
    Pos : Integer := 0;
    Dir : Direction := Forward;

begin

    Initialize_NeoPixel;
    
    Fill(Strip_1, Color_1);
    Set_Color(Strip_1, 0, (0, 0, 0, 0) );
    Strip_1.Show;
    delay until Clock + Milliseconds(150);

    Infinite :
    loop
        
        if Dir = Forward then
            
            if Pos >= (Strip_1.Get_Count - 1) then
                Dir := Backward;
                Rotate_Buffer(Strip_1, -1);
                Pos := Pos - 1;
            else
                Dir := Forward;
                Rotate_Buffer(Strip_1, 1);
                Pos := Pos + 1;
            end if;

        else
            
            if Pos <= 0 then
                Dir := Forward;
                Rotate_Buffer(Strip_1, 1);
                Pos := Pos + 1;
            else
                Dir := Backward;
                Rotate_Buffer(Strip_1, -1);
                Pos := Pos - 1;
            end if;

        end if;

        Strip_1.Show;

        delay until Clock + Milliseconds(150);

    end loop Infinite;


end cylon_eye_inverted;
