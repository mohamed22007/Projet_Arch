library IEEE;
use IEEE.std_logic_1164.all;

entity clkUnit is
 port (
        clk, reset : in  std_logic;
        enableTX   : out std_logic;
        enableRX   : out std_logic
      );
end clkUnit;

architecture behavorial of clkUnit is

  COMPONENT diviseurClkTX is 
    PORT (
         clk, reset : in  std_logic;
    nclk       : out std_logic);

  END COMPONENT;

  COMPONENT diviseurClkRX is 
    PORT (
         clk, reset : in  std_logic;
    nclk       : out std_logic);

  END COMPONENT;

begin

  -- affectation des sorties pour que la simulation et la génération du bitstream aillent jusqu'au bout
  U1 : diviseurClkTX Port map (
    clk => clk ,
    reset => reset ,
    nclk => enableTX
  );

  U2 : diviseurClkRX Port map (
    clk => clk ,
    reset => reset ,
    nclk => enableRX
  );


end behavorial;
