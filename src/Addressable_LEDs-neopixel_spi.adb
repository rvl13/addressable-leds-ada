package body Addressable_LEDs.neopixel_spi is


    ------------
    -- Create --
    ------------

    function Create (Mode : LED_Mode; Count : Positive; Reset_Last : Positive; Port : not null Any_SPI_Port) return LED_Strip_ws2812b_SPI is
    begin
        return LED_Strip_ws2812b_SPI'(Mode     => Mode,
                                Count    => Count,
                                Buf_Last => Count * Stride (Mode) - 1,
                                Bit_Last => Count * Stride (Mode) * 8 - 1,
                                Reset_Last => Reset_Last,
                                Port => Port,
                                Buffer   => (others => 0),
                                BitStream => (others => Bit_0),
                                ResetStream => (others => Bit_Reset));
    end Create;

    
    ----------
    -- Show --
    ----------

    overriding
    procedure Show(Strip : in out LED_Strip_ws2812b_SPI) is
    begin
        Strip.Generate_BitStream;
        Strip.Flash_BitStream;
    end Show;


    ------------------------
    -- Generate_BitStream --
    ------------------------

    procedure Generate_BitStream(Strip : in out LED_Strip_ws2812b_SPI) is
        Base : Natural := 0;
        Indices : constant Component_Indices := Mode_Indices (Strip.Mode);
        BitStream_Index : Natural := 0;
        Buffer_Index : Natural := 0;
    begin
        iterate_pixels:
        for Pixel in Natural range 0 .. (Strip.Count - 1) loop
        Base := Pixel * Stride (Strip.Mode);

            iterate_components:
            for Component in LED_Red .. (if Strip.Mode = RGBW then LED_White else LED_Blue) loop
            Buffer_Index := Base + Indices(Component);

                iterate_bits:
                for bit_index in Natural range 0 .. 7 loop
                    BitStream_Index := ( 8 * Stride(Strip.Mode) * Pixel ) + ( 8 * Indices(Component) ) + bit_index;

                    if ( Strip.Buffer(Buffer_Index) and Shift_Left(2#00000001#, (7 - bit_index)) ) > 0 then
                        Strip.BitStream( BitStream_Index ) := Bit_1;
                    else
                        Strip.BitStream( BitStream_Index ) := Bit_0;
                    end if;

                end loop iterate_bits;

            end loop iterate_components;

        end loop iterate_pixels;
    end Generate_BitStream;

    ---------------------
    -- Flash_BitStream --
    ---------------------

    procedure Flash_BitStream(Strip : in LED_Strip_ws2812b_SPI) is
        Status : HAL.SPI.SPI_Status;
    begin
        Strip.Port.Transmit(Strip.ResetStream & Strip.BitStream & Strip.ResetStream , Status);
    end Flash_BitStream;


end Addressable_LEDs.neopixel_spi;
