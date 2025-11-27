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

begin

  -- affectation des sorties pour que la simulation et la génération du bitstream aillent jusqu'au bout
  -- À EFFACER
  enableTX <= '0';
  enableRX <= '0';

end behavorial;
