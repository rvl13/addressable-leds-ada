package body SPI_config is


    -------------------------
    -- Initialize_NeoPixel --
    -------------------------

    procedure Initialize_NeoPixel is
        procedure Init_SPI;
        procedure Init_GPIO;


        --------------
        -- Init_SPI --
        --------------

        procedure Init_SPI is
            Config : SPI_Configuration;
        begin
            Enable_Clock (Npxl_SPI);

            Config.Mode := Master;
            Config.Baud_Rate_Prescaler := BRP_8;        -- approx. 5.25 MHz
            Config.Clock_Polarity := Low;
            Config.Clock_Phase := P1Edge;
            Config.First_Bit := MSB;
            Config.CRC_Poly := 7;
            Config.Slave_Management := Software_Managed;
            Config.Direction := D1Line_Tx;
            Config.Data_Size := HAL.SPI.Data_Size_8b;

            Disable (Npxl_SPI);
            Configure (Npxl_SPI, Config);
            Enable (Npxl_SPI);
        end Init_SPI;


        ---------------
        -- Init_GPIO --
        ---------------

        procedure Init_GPIO is
            SPI_Point : constant GPIO_Point := Npxl_SPI_MOSI_Pin;
        begin
            Enable_Clock (SPI_Point);

            Configure_IO (SPI_Point,
                (Mode_AF,
                AF             => Npxl_SPI_AF,
                Resistors      => Floating,
                AF_Speed       => Speed_50MHz,
                AF_Output_Type => Push_Pull));

        end Init_GPIO;

    begin
        Init_GPIO;
        Init_SPI;
    end Initialize_NeoPixel;

end SPI_config;
