with HAL; use HAL;
with HAL.SPI; --use HAL.SPI;
with STM32; use STM32;
with STM32.SPI; use STM32.SPI;
with STM32.GPIO;    use STM32.GPIO;
with STM32.Device;  use STM32.Device;


package SPI_config is

    -- No need to use SCK and MISO pins, 
    -- since we will transmitting only with MOSI pin

    Npxl_SPI : SPI_Port renames SPI_2;
    Npxl_SPI_AF : GPIO_Alternate_Function renames GPIO_AF_SPI2_5;
    --Npxl_SPI_SCK_Pin     : GPIO_Point renames PB13;
    --Npxl_SPI_MISO_Pin    : GPIO_Point renames PB14;
    Npxl_SPI_MOSI_Pin    : GPIO_Point renames PB15;


    procedure Initialize_NeoPixel;

end SPI_config;
