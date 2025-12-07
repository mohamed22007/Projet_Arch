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

  -- États de l'automate
  signal etat : std_logic_vector(2 downto 0) := "000";

  -- Tampon de transmission
  signal Buffer_T : std_logic_vector(7 downto 0);

  -- Registre d’émission
  signal Register_T : std_logic_vector(7 downto 0);

begin

  unite_proc: process(clk, reset)

    -- Compteur des bits transmis
    variable cpt : natural := 7;

  begin

    -- Réinitialisation de l'unité
    if reset = '0' then

      etat      <= "000";     -- État initial
      Buffer_T  <= (others => '0');
      txd       <= '1';       -- Ligne au repos
      regE      <= '1';       -- Registre libre
      bufE      <= '1';       -- Tampon libre

    elsif rising_edge(clk) then

      -- Automate principal
      case etat is

        -- État initial
        when "000" =>

          -- Attente d’une demande d’émission
          if ld = '1' then
            Buffer_T <= data;   -- Chargement des données
            bufE     <= '0';
            etat     <= "001";
          end if;

        -- Transfert du tampon vers le registre
        when "001" =>
          Register_T <= Buffer_T;
          bufE       <= '1';
          regE       <= '0';
          etat       <= "010";

        -- Envoi du bit de start
        when "010" =>

          -- Début de trame si autorisé
          if enable = '1' then
            txd <= '0';         -- Bit de start
            cpt := 7;
            etat <= "011";

            -- Charger une nouvelle donnée si le tampon est libre
            if ld = '1' and bufE = '1' then
              Buffer_T <= data;
              bufE <= '0';
            end if;

          end if;

        -- Transmission des bits de données
        when "011" =>

          if (cpt > 0 and enable = '1') then
            txd <= Register_T(cpt);
            cpt := cpt - 1;

          elsif (cpt = 0 and enable = '1') then
            txd  <= Register_T(0);
            etat <= "100";  -- Passage au bit de stop
          end if;

          -- Charger une donnée si le tampon est libre
          if ld = '1' and bufE = '1' then
            Buffer_T <= data;
            bufE <= '0';
          end if;

        -- Fin de transmission de la trame
        when "100" =>

          -- S’il y a une nouvelle trame en attente
          if bufE = '0' and enable = '1' then
            txd  <= '1';      -- Bit de stop
            regE <= '1';
            etat <= "001";

          -- Sinon, retour à l’état initial
          elsif bufE = '1' and enable = '1' then
            txd  <= '1';
            regE <= '1';
            etat <= "000";
          end if;

          -- Charger une nouvelle donnée si le tampon est libre
          if ld = '1' and bufE = '1' then
            Buffer_T <= data;
            bufE <= '0';
          end if;

        when others =>
          null;

      end case;

    end if;

  end process;

end behavorial;
