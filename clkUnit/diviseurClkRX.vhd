library IEEE;
use IEEE.std_logic_1164.all;

entity diviseurClkRX is
  -- facteur : ratio entre la fréquence de l'horloge origine et celle
  --           de l'horloge générée
  --  ex : 100 MHz -> 1Hz : 100 000 000
  --  ex : 100 MHz -> 1kHz : 100 000
  port (
    clk, reset : in  std_logic;
    nclk       : out std_logic);
end diviseurClkRX;

architecture arch_divClk of diviseurClkRX is

  signal top : std_logic := '0';
  constant facteur : natural := 10;
  
begin  

  div : process (clk, reset)
    variable cpt : integer range 0 to facteur-1 := 0;
  begin 
    if reset = '0' then
      nclk <= '0';
      cpt := 0;
    elsif rising_edge(clk) then
      if(cpt = facteur - 1) then
        cpt := 0;
      else
        cpt := cpt + 1;
      end if;
      if cpt = 0 then
        nclk <= '1';
      else
        nclk <= '0';
      end if;
    end if;
  end process;

end arch_divClk;
