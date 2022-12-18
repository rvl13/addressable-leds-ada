------------------------------------------------------------------------------
--                                                                          --
--                        Copyright (C) 2019, AdaCore                       --
--                                                                          --
--  Redistribution and use in source and binary forms, with or without      --
--  modification, are permitted provided that the following conditions are  --
--  met:                                                                    --
--     1. Redistributions of source code must retain the above copyright    --
--        notice, this list of conditions and the following disclaimer.     --
--     2. Redistributions in binary form must reproduce the above copyright --
--        notice, this list of conditions and the following disclaimer in   --
--        the documentation and/or other materials provided with the        --
--        distribution.                                                     --
--     3. Neither the name of the copyright holder nor the names of its     --
--        contributors may be used to endorse or promote products derived   --
--        from this software without specific prior written permission.     --
--                                                                          --
--   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS    --
--   "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT      --
--   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR  --
--   A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT   --
--   HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, --
--   SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT       --
--   LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,  --
--   DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY  --
--   THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT    --
--   (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE  --
--   OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.   --
--                                                                          --
------------------------------------------------------------------------------

-- The implementation of this package Addressable_LEDs is inspired from the 
-- of neopixel middleware package provided with Ada_Drivers_Library, here :
-- https://github.com/AdaCore/Ada_Drivers_Library/tree/master/middleware/src/neopixel

with HAL; use HAL;


package Addressable_LEDs IS

    type LED_Component is (LED_Red, LED_Green, LED_Blue, LED_White);
    
    subtype LED_Value is UInt8;
    
    -- more sequences can be added to below
    type LED_Mode is
        (GRB,   --  Most NeoPixel products (WS2812)
        RGB,   --  FLORA v1 (not v2) pixels
        RGBW); --  NeoPixel RGB+white products

    -- This refers to a value of single LED pixel
    type LED_Values is array (LED_Component) of LED_Value;

    -- Some commonly used colors
    Red    : constant LED_Values := (LED_Red => 255, others => 0);
    Orange : constant LED_Values := (LED_Red => 255, LED_Green => 165, others => 0);
    Yellow : constant LED_Values := (LED_Red | LED_Green => 255, others => 0);
    Green  : constant LED_Values := (LED_Green => 255, others => 0);
    Cyan   : constant LED_Values := (LED_Green | LED_Blue => 255, others => 0);
    Blue   : constant LED_Values := (LED_Blue  => 255, others => 0);
    Indigo : constant LED_Values := (LED_Red => 75, LED_Blue => 130, others => 0);
    Purple : constant LED_Values := (LED_Red | LED_Blue => 255, others => 0);
    White  : constant LED_Values := (others => 255);
    Black  : constant LED_Values := (others => 0);

    type Component_Indices is array (LED_Component) of Integer;
    Mode_Indices : constant array (LED_Mode) of Component_Indices :=
        (RGB  => (LED_Red => 0, LED_Green => 1, LED_Blue => 2, LED_White => -1),
        GRB  => (LED_Red => 1, LED_Green => 0, LED_Blue => 2, LED_White => -1),
        RGBW => (LED_Red => 0, LED_Green => 1, LED_Blue => 2, LED_White => 3));

    -- Stride contains BPP (number of "Bytes Per Pixel" ) for given LED_MODE
    Stride : constant array (LED_Mode) of Positive :=
        (RGBW => 4, others => 3);

    type LED_Strip (<>) is abstract tagged private;

    -- not decalring even an abstract funtion "Create" to create the object of this class.
    -- because future extension of this record type (LED_Strip) may require different set of 
    -- initialization paramaters, in such case this function can't be override.
    -- Hence, declare and define this function for each of the type extension.
    -- For example, derived type LED_Strip_SPI has parameter to pass access to SPI port being used.
    -- Similarly, if you are create an record extension for APA102 (aka Dotstars),
    -- then you would require to provide value of brightness.
    -- So, a single function can not cater for different future type extensions. 
    ------------------------------------------------------------------------------------------
    --function Create (Mode : LED_Mode; Count : Positive) return LED_Strip is abstract;

    function Get_Mode(Strip : LED_Strip) return LED_Mode;

    function Get_Count(Strip : LED_Strip) return Positive;

   --  Set the color of the designated pixel to the given color
    procedure Set_Color
        (Strip : out LED_Strip;
        Index : Natural;
        Color : LED_Values);

    --  Get the color of the designated pixel
    function Get_Color (Strip : LED_Strip; Index : Natural) return LED_Values;

    -- Transmit the bits to display the colors on LED strip.
    procedure Show(Strip : in out LED_Strip) is abstract;

private

    type LED_Strip (Mode : LED_Mode; Count : Positive; Buf_Last : Positive) is abstract tagged
        record
            Buffer : aliased UInt8_Array (0 .. Buf_Last);
        end record;
    
end Addressable_LEDs;
