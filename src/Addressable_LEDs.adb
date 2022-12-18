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

package body Addressable_LEDs is

    --------------
    -- Get_Mode --
    --------------

    function Get_Mode(Strip : LED_Strip) return LED_Mode is
    begin
        return Strip.Mode;
    end Get_Mode;


    ---------------
    -- Get_Count --
    ---------------

    function Get_Count(Strip : LED_Strip) return Positive is
    begin
        return Strip.Count;
    end Get_Count;


    ---------------
    -- Set_Color --
    ---------------

    procedure Set_Color
        (Strip : out LED_Strip;
        Index : Natural;
        Color : LED_Values)
    is
        pragma Assert (Index < Strip.Count);
        Base    : constant Natural := Index * Stride (Strip.Mode);
        Indices : constant Component_Indices := Mode_Indices (Strip.Mode);
    begin
        for J in LED_Red .. (if Strip.Mode = RGBW then LED_White else LED_Blue) loop
            Strip.Buffer (Base + Indices (J)) := Color (J);
        end loop;
    end Set_Color;

    ---------------
    -- Get_Color --
    ---------------

    function Get_Color (Strip : LED_Strip; Index : Natural) return LED_Values is
        pragma Assert (Index < Strip.Count);
        Color : LED_Values := (others => 0);
        Base    : constant Natural := Index * Stride (Strip.Mode);
        Indices : constant Component_Indices := Mode_Indices (Strip.Mode);
    begin
        for J in LED_Red .. (if Strip.Mode = RGBW then LED_White else LED_Blue) loop
            Color (J) := Strip.Buffer (Base + Indices (J));
        end loop;

        return Color;
    end Get_Color;

end Addressable_LEDs;

