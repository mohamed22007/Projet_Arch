library IEEE;
use IEEE.std_logic_1164.all;

entity TxUnit is
  port (
    clk, reset : in std_logic;
    enable     : in std_logic;
    ld         : in std_logic;
    txd        : out std_logic;
    regE       : out std_logic;
    bufE       : out std_logic;
    data       : in std_logic_vector(7 downto 0));
end TxUnit;

architecture behavorial of TxUnit is

  signal etat : std_logic_vector (2 downto 0) := "000";
  signal Buffer_T : std_logic_vector(7 downto 0);
  signal Register_T : std_logic_vector(7 downto 0);

begin

  -- affectation des sorties pour que la simulation aille jusqu'au bout
  unite_proc: process (clk , reset)
    variable cpt : natural := 7;
  begin
    if reset = '0' then
      etat <= "000";
      enable <='0';
      Buffer_T <= (others => "0");
      txd <= '1';
    elsif (rising_edge clk)
      case etat is
    when "000" => 
    if (ld = "1") then
      Buffer_T <= data;
      bufE <= '0';
      etat <= "001"
    end if;
    
    when "001" =>
    Register_T <= Buffer_T;
    bufE <= '1';
    regE <= '0';

    when "010" =>
      if (enable = '1')then
      txd <= '0';
      cpt := 7;
      etat <= "011"
      end if;

    when "011" => 
    if (cpt > 0 and enable = '1') then
      txd <= Register_T(cpt);
      cpt := cpt - 1;
    elsif (cpt = 0 and enable ='1') then
      txd <= Register_T(cpt);
      etat <= "100"
    end if;

    when "100" => 
    if (bufE ='1' and enable ='1') then
      txd <= '1';
      regE <= '1';
      etat <= "001"
    elsif (bufE = '0' and enable = '1') then
      Btxd <= '1';
      regE <= '1';
      etat <= "000";
    end if;
  end case;
end if;

end process;



end behavorial;
