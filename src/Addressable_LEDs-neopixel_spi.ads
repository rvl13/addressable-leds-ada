with Addressable_LEDs; use Addressable_LEDs;
with HAL.SPI; use HAL.SPI;

package Addressable_LEDs.neopixel_spi is

    type LED_Strip_ws2812b_SPI(<>) is new LED_Strip with private;

    -- Here we declare "Create" funtion to Construct object of type "LED_Strip_SPI"
    function Create (Mode : LED_Mode; Count : Positive; Reset_Last : Positive; Port : not null Any_SPI_Port) return LED_Strip_ws2812b_SPI;

    -- overriding the abstract procedure defined for LED_Strip
    overriding
    procedure Show(Strip : in out LED_Strip_ws2812b_SPI);

private

    procedure Generate_BitStream(Strip : in out LED_Strip_ws2812b_SPI);

    procedure Flash_BitStream(Strip : in LED_Strip_ws2812b_SPI);

    --Bit_0 : constant UInt8 := 2#10000000#;     -- 128 in Decimal
    --Bit_1 : constant UInt8 := 2#11110000#;      -- 240 in Decimal
    -- Use the above two, if below two do not work as expected.
    Bit_0 : constant UInt8 := 2#11000000#;      -- 192 in Decimal
    Bit_1 : constant UInt8 := 2#11111000#;      -- 248 in Decimal
    Bit_Reset : constant UInt8 := 2#00000000#;

    type LED_Strip_ws2812b_SPI(Mode : LED_Mode; Count : Positive; Buf_Last : Positive; Bit_Last : Positive; Reset_Last : Positive; Port : not null Any_SPI_Port) is new LED_Strip(Mode => Mode, Count => Count, Buf_Last => Buf_Last) with
        record
            BitStream : aliased SPI_Data_8b (0 .. Bit_Last);
            ResetStream : aliased SPI_Data_8b (0 .. Reset_Last);
        end record;

end Addressable_LEDs.neopixel_spi;
