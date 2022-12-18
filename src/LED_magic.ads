-- This package defines some very basic and useful functions
-- to manipulate the buffers conveniently.

-- The operations defined here are class wide (for LED_Strip class).
-- So any future type extension of LED_Strip,
-- which does not differ from the way LED_Strip works,
-- will be able to make use of this package.


with HAL; use HAL;
with Addressable_LEDs; use Addressable_LEDs;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Numerics; use Ada.Numerics;
with Ada.Numerics.Elementary_Functions; use Ada.Numerics.Elementary_Functions;

package LED_magic is

    -- Color Palette can be useful for storing a limited number of colors.
    -- and then transfer these colors to buffer for LED_Strip.
    type Color_Palette is array (Natural range <>) of LED_Values;
    type Angle_Degrees is mod 360;
   
    type Pixel_Mode is (Fill_Pixels, Unfill_Pixels);
    type Direction is (Forward, Backward); 
    type Effect_Mode is (Converge, Diverge);

    -- Fill all the pixels with given "Color"
    procedure Fill(Strip : out LED_Strip'Class; Color : LED_Values);

    -- Fill all the pixels between indices Start .. Stop, with given "Color"
    procedure Fill(Strip : out LED_Strip'Class; Color : LED_Values; Start : Natural; Stop : Natural);

    -- Rotate the buffer,
    -- Positive values rotate forwards and
    -- Negative values rotate backwards.
    procedure Rotate_Buffer(Strip : in out LED_Strip'Class; Steps : in Integer);

    -- Mirror the buffer.
    procedure Mirror_Buffer(Strip : in out LED_Strip'Class);

    -- "Magic_copy" (aka Modulo_Copy)
    -- Copies colors from "Src" Palette to "Dest" LED_Strip object's Buffer,
    -- Starting from "Offset_raw" index of Src mapping to index "0" of LED_Strip. 
    -- Takes care of different sizes of "Src" and "Dest" :
    -- i.  Repeats colors if Src'Length is Less than Dest'Length (in terms of colors).
    -- ii. Limits copy of further colors if Src'Length is greater than Dest'Length.
    procedure Magic_Copy (Src : in Color_Palette; Dest : out LED_Strip'Class; Offset_raw : in Integer := 0);

    -- Generate rainbow palette based on colors returned by "Colorwheel_8bit" function.
    procedure Generate_Rainbow1_Palette(Palette : out Color_Palette);

    -- Generate rainbow palette based on colors returned by "Colorwheel_3phase" function.
    procedure Generate_Rainbow2_Palette(Palette : out Color_Palette);

    -- Generates a monochromatic gradient palette.
    -- Where the first color is same as the passed argument "Color",
    -- last color is first color dimmed by value "Factor",
    -- and rest of the colors in between are simply linear distribution between first and last.
    procedure Generate_Monochromatic_Gradient_Palette (Palette : out Color_Palette; Color : in LED_Values; Factor : in Positive);

private

    procedure Rotate_Once_Forward(Strip : in out LED_Strip'Class);

    procedure Rotate_Once_Backward(Strip : in out LED_Strip'Class);

    -- returns a color based on 8-bit Colorwheel
    -- (max 256 possible colors).
    function ColorWheel_8bit (Pos : UInt8) return LED_Values;

    -- returns a color based on a 3-phase sinewave :
    -- (mutual phase difference of 120 degrees between each two phases)
    -- where R,G and B represent amplitude of sinewaves of respective phases (0, 120 and 240 degrees).
    -- Note that sinewaves are shifted up to avoid negative values.
    -- (max 360 possible colors)
    function ColorWheel_3phase (Pos : Angle_Degrees) return LED_Values;

end LED_magic;
