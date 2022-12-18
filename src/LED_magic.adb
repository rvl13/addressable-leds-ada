package body LED_magic is

    ----------
    -- Fill --
    ----------

    procedure Fill(Strip : out LED_Strip'Class; Color : LED_Values) is
    begin
        iterate_pixels:
        for pixel in Natural range 0 .. (Strip.Get_Count - 1) loop
            Strip.Set_color(pixel, Color);
        end loop iterate_pixels;
    end Fill;


    ----------
    -- Fill --
    ----------

    procedure Fill(Strip : out LED_Strip'Class; Color : LED_Values; Start : Natural; Stop : Natural) is
        pragma Assert (Start < Strip.Get_Count);
        pragma Assert (Stop < Strip.Get_Count);
        pragma Assert (Start <= Stop);
    begin
        iterate_pixels:
        for pixel in Natural range Start .. Stop loop
            Strip.Set_color(pixel, Color);
        end loop iterate_pixels;
    end Fill;


    -------------------
    -- Rotate_Buffer --
    -------------------

    procedure Rotate_Buffer(Strip : in out LED_Strip'Class; Steps : in Integer) is
        Steps_Absolute : constant Natural := (abs Steps) mod (Strip.Get_Count) ;
    begin
        if (Steps > 0) then

            loop_forward :
            for I in Natural range 1 .. Steps_Absolute loop
                Rotate_Once_Forward(Strip);
            end loop loop_forward;

        elsif (Steps < 0) then
            
            loop_backward :
            for I in Natural range 1 .. Steps_Absolute loop
                Rotate_Once_Backward(Strip);
            end loop loop_backward;
        
        else
            null;
        end if;
    end Rotate_Buffer;


    -------------------
    -- Mirror_Buffer --
    -------------------

    procedure Mirror_Buffer(Strip : in out LED_Strip'Class) is
        Middle_Index, Mirror_Index : Natural := 0;
        Color_Temp : LED_Values := Black;
        Count_N : constant Natural := Strip.Get_Count; 
    begin
        if ( (Strip.Get_Count mod 2) = 0) then
            Middle_Index := (Count_N / 2) - 1;
        else
            Middle_Index := (Count_N - 1) / 2;
        end if;

        loop_half :
        for I in Natural range 0 .. Middle_Index loop
            Mirror_Index := (Count_N - 1) - I;
            Color_Temp := Black;
            Color_Temp := Strip.Get_Color(I);
            Strip.Set_color(I, Strip.Get_Color(Mirror_Index));
            Strip.Set_color(Mirror_Index, Color_Temp);
        end loop loop_half;

    end Mirror_Buffer;


    -------------------------
    -- Rotate_Once_Forward --
    -------------------------

    procedure Rotate_Once_Forward(Strip : in out LED_Strip'Class) is
        Start : constant Natural := 0;
        Stop : constant Natural := Strip.Get_Count - 1;
        Last_Color : constant LED_Values := Strip.Get_Color(Stop);
    begin
        for I in reverse Natural range (Start + 1) .. Stop loop
            Strip.Set_color(I, Strip.Get_Color(I - 1));
        end loop;
        Strip.Set_color(Start, Last_Color);
    end Rotate_Once_Forward;


    --------------------------
    -- Rotate_Once_Backward --
    --------------------------

    procedure Rotate_Once_Backward(Strip : in out LED_Strip'Class) is
        Start : constant Natural := 0;
        Stop : constant Natural := Strip.Get_Count - 1;
        First_Color : constant LED_Values := Strip.Get_Color(Start);
    begin
        for I in Natural range Start .. (Stop - 1) loop
            Strip.Set_color(I, Strip.Get_Color(I + 1));
        end loop;
        Strip.Set_color(Stop, First_Color);
    end Rotate_Once_Backward;


    ----------------
    -- Magic_Copy --
    ----------------

    procedure Magic_Copy (Src : in Color_Palette; Dest : out LED_Strip'Class; Offset_Raw : in Integer := 0) is
        Src_Length : constant Natural := Src'Length;
        Dest_Length : constant Natural := Dest.Get_Count;
        Offset : constant Natural := Offset_Raw mod Src_Length;
        J : Natural := 0;
    begin
        iterate_pixels :
        for I in Natural range 0 .. (Dest_Length - 1) loop
            J := (I + Offset) mod Src_Length;
            Dest.Set_color(I, Src(J) );
        end loop iterate_pixels;

    end Magic_Copy;


    ---------------------
    -- ColorWheel_8bit --
    ---------------------

    function ColorWheel_8bit (Pos : UInt8) return LED_Values is
        Color_Out : LED_Values := Black;
        Pos_Temp : UInt8 := 0;
    begin
        if Pos < 85 then
            Pos_Temp := Pos;
            Color_Out := ( (Pos_Temp * 3) , (255 - ( Pos_Temp * 3 ) ) , 0, 0);
        elsif Pos < 170 then
            Pos_Temp := Pos - 85;
            Color_Out := ( (255 - ( Pos_Temp * 3 ) ) , 0, (Pos_Temp * 3) , 0);
        else
            Pos_Temp := Pos - 170;
            Color_Out := ( 0, (Pos_Temp * 3) , (255 - ( Pos_Temp * 3 ) ) , 0);
        end if;

        return Color_Out;
    end ColorWheel_8bit;


    -------------------------------
    -- Generate_Rainbow1_Palette --
    -------------------------------

    procedure Generate_Rainbow1_Palette(Palette : out Color_Palette) is
        Pos : UInt8 := 0;
        Pos_Temp : Float := 0.0;
        Palette_Length : constant Natural := Palette'Length;
        Color_Temp : LED_Values := Black;
    begin
        if Palette_Length > Natural(UInt8'Last) then         -- You can also put (UInt8'Last + 1)
            
            iterate_palette:
            for I in Palette'range loop
                Pos := UInt8(I mod 256);
                Color_Temp := ColorWheel_8bit(Pos);
                Palette(I) := Color_Temp;
            end loop iterate_palette;
        
        else
            linear_sampling:
            for I in Palette'range loop
                Pos_Temp := ( Float(I) * 255.0 ) / Float(Palette_Length);
                Pos := UInt8( Natural(Pos_Temp) mod 256 );
                Color_Temp := ColorWheel_8bit(Pos);
                Palette(I) := Color_Temp;
            end loop linear_sampling;
        end if;
    end Generate_Rainbow1_Palette;


    ----------------
    -- Deg_To_Rad --
    ----------------

    function Deg_To_Rad (Pos : Angle_Degrees) return Float is
    begin
        return (Float(Pos) * Float(Pi) ) / (180.0);
    end Deg_To_Rad;


    -----------------------
    -- ColorWheel_3phase --
    -----------------------

    function ColorWheel_3phase (Pos : Angle_Degrees) return LED_Values is
        Color_Out : LED_Values := Black;
        R_Out, G_out, B_Out : LED_Value := 0;
        Phase_Deg : Float := 0.0;
        Phase_Rad_Red, Phase_Rad_Green, Phase_Rad_Blue : Float := 0.0;
        Value_Red, Value_Green, Value_Blue : Float := 0.0; 
    begin

        Phase_Rad_Red := Deg_To_Rad(Pos + 0);
        Phase_Rad_Green := Deg_To_Rad(Pos + 120);
        Phase_Rad_Blue := Deg_To_Rad(Pos + 240);

        Value_Red := (255.0) * ( (Sin(Phase_Rad_Red) + 1.0) / 2.0);
        Value_Green := (255.0) * ( (Sin(Phase_Rad_Green) + 1.0) / 2.0);
        Value_Blue := (255.0) * ( (Sin(Phase_Rad_Blue) + 1.0) / 2.0);

        R_Out := LED_Value(Value_Red);
        G_out := LED_Value(Value_Green);
        B_Out := LED_Value(Value_Blue);

        Color_Out := (R_Out, G_out, B_Out, 0);
        return Color_Out;
    end ColorWheel_3phase;


    -------------------------------
    -- Generate_Rainbow2_Palette --
    -------------------------------

    procedure Generate_Rainbow2_Palette(Palette : out Color_Palette) is
        Pos : Angle_Degrees := 0;
        Pos_Temp : Float := 0.0;
        Palette_Length : constant Natural := Palette'Length;
        Color_Temp : LED_Values := Black;
    begin
        if Palette_Length > Natural(Angle_Degrees'Last) then

            iterate_palette:
            for I in Palette'range loop
                Pos := Angle_Degrees(I mod 360);
                Color_Temp := ColorWheel_3phase(Pos);
                Palette(I) := Color_Temp;
            end loop iterate_palette;

        else
            linear_sampling:
            for I in Palette'range loop
                Pos_Temp := ( Float(I) * 360.0 ) / Float(Palette_Length);
                Pos := Angle_Degrees( Natural(Pos_Temp) mod 360 );
                Color_Temp := ColorWheel_3phase(Pos);
                Palette(I) := Color_Temp;
            end loop linear_sampling;
        end if;
    end Generate_Rainbow2_Palette;


    ---------------------------------------------
    -- Generate_Monochromatic_Gradient_Palette --
    ---------------------------------------------

    procedure Generate_Monochromatic_Gradient_Palette (Palette : out Color_Palette; Color : in LED_Values; Factor : in Positive) is
        Palette_Length : constant Natural := Palette'Length;
        Factor_Dimming : constant Float := Float(Factor);
        R1 : constant Float := Float(Color(LED_Red));
        G1 : constant Float := Float(Color(LED_Green));
        B1 : constant Float := Float(Color(LED_Blue));
        W1 : constant Float := Float(Color(LED_White));
        R2 : constant Float := R1 / Factor_Dimming;
        G2 : constant Float := G1 / Factor_Dimming;
        B2 : constant Float := B1 / Factor_Dimming;
        W2 : constant Float := W1 / Factor_Dimming;
        R_Temp, G_Temp, B_Temp, W_Temp : Float := 0.0;
        R_Out, G_out, B_Out, W_Out : LED_Value := 0;
    begin
        iterate_palette:
        for I in Palette'range loop
            if Palette_Length > 1 then
                R_Temp := ( (R2 - R1) / ( Float(Palette_Length) - 1.0) ) * (Float(I) - 0.0) + R1;
                G_Temp := ( (G2 - G1) / ( Float(Palette_Length) - 1.0) ) * (Float(I) - 0.0) + G1;
                B_Temp := ( (B2 - B1) / ( Float(Palette_Length) - 1.0) ) * (Float(I) - 0.0) + B1;
                W_Temp := ( (W2 - W1) / ( Float(Palette_Length) - 1.0) ) * (Float(I) - 0.0) + W1;

                R_Out := LED_Value(R_Temp);
                G_out := LED_Value(G_Temp);
                B_Out := LED_Value(B_Temp);
                W_Out := LED_Value(W_Temp);

                Palette(I) := (R_Out, G_out, B_Out, W_Out);
            else
                Palette(I) := Color;
            end if;
        end loop iterate_palette;
    end Generate_Monochromatic_Gradient_Palette;


end LED_magic;