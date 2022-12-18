-- diverging_bars

with Addressable_LEDs; use Addressable_LEDs;
with Addressable_LEDs.neopixel_spi; use Addressable_LEDs.neopixel_spi;
with SPI_config; use SPI_config;
with LED_magic; use LED_magic;
with Ada.Real_Time; use Ada.Real_Time;

procedure diverging_bars is

    Strip_count : constant Positive := 5;
    Strip_mode : constant LED_Mode := GRB;
    Strip_1 : aliased LED_Strip_ws2812b_SPI := Create(Strip_mode, Strip_count, 8, Npxl_SPI'Access);

    Palette_1 : constant Color_Palette(0 .. 6) := ( (125, 0, 0, 0), (0, 125, 0, 0), (0, 0, 125, 0), (125, 125, 0, 0), (0, 125, 125, 0), (125, 0, 125, 0), (125, 125, 125, 0) );
    PixMode : Pixel_Mode := Fill_Pixels;
    Effect : constant Effect_Mode := Diverge;
    Color_Index : Integer := 0;
    Current_Index, Mirror_Index, Middle_Index, Start_Index, Stop_Index : Integer := 0;
    Step_Difference : Integer := 0;

begin

    Initialize_NeoPixel;

    if ((Strip_1.Get_Count mod 2) = 0) then
        Middle_Index := (Strip_1.Get_Count / 2) - 1;
    else
        Middle_Index := (Strip_1.Get_Count - 1) / 2;
    end if;

    if Effect = Converge then
        Start_Index := 0;
        Stop_Index := Middle_Index;
        Current_Index := Start_Index;
        Mirror_Index := (Strip_1.Get_Count - 1) - Current_Index;
        Step_Difference := 1;
    else
        Start_Index := Middle_Index;
        Stop_Index := 0;
        Current_Index := Start_Index;
        Mirror_Index := (Strip_1.Get_Count - 1) - Current_Index;
        Step_Difference := -1;
    end if;

    Infinite :
    loop

        if PixMode = Fill_Pixels then
            Set_Color(Strip_1, Current_Index, Palette_1(Color_Index) );
            Set_Color(Strip_1, Mirror_Index, Palette_1(Color_Index) );
        else
            Set_Color(Strip_1, Current_Index, (0, 0, 0, 0) );
            Set_Color(Strip_1, Mirror_Index, (0, 0, 0, 0) );
        end if;

        if Current_Index = Stop_Index then
            Current_Index := Start_Index;
            Mirror_Index := (Strip_1.Get_Count - 1) - Current_Index;

            if PixMode = Fill_Pixels then
                PixMode := Unfill_Pixels;
            else
                PixMode := Fill_Pixels;
                Color_Index := (Color_Index + 1) mod (Palette_1'Length);
            end if;
        else
            Current_Index := Current_Index + Step_Difference;
            Mirror_Index := (Strip_1.Get_Count - 1) - Current_Index;
        end if;

        Strip_1.Show;

        delay until Clock + Milliseconds(150);

    end loop Infinite;


end diverging_bars;
