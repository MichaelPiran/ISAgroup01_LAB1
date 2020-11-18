library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;
use WORK.fir_package.all;
library std;
use std.textio.all;

entity data_maker is
  port (
    CLK     : in  std_logic;
    RST_n   : in  std_logic;
    VOUT    : out std_logic;
    DOUT    : out signed(nb-1 downto 0);
	DOUT1   : out signed(nb-1 downto 0);
	DOUT2   : out signed(nb-1 downto 0);
    H0      : out signed(nb-1 downto 0);
	H1      : out signed(nb-1 downto 0);
	H2      : out signed(nb-1 downto 0);
	H3      : out signed(nb-1 downto 0);
	H4      : out signed(nb-1 downto 0);
	H5      : out signed(nb-1 downto 0);
	H6      : out signed(nb-1 downto 0);
	H7      : out signed(nb-1 downto 0);
	H8      : out signed(nb-1 downto 0);
	H9      : out signed(nb-1 downto 0);
	H10     : out signed(nb-1 downto 0);
    END_SIM : out std_logic);
end data_maker;

architecture beh of data_maker is

  constant tco : time := 1 ns;

  signal sEndSim : std_logic;
  signal END_SIM_i : std_logic_vector(0 to 10);

begin  -- beh

  -- H = b coeff
  H0 <= conv_signed(-1,nb);
  H1 <= conv_signed(-52,nb);
  H2 <= conv_signed(-102,nb);
  H3 <= conv_signed(260,nb);
  H4 <= conv_signed(1125,nb);
  H5 <= conv_signed(1630,nb);
  H6 <= conv_signed(1125,nb);
  H7 <= conv_signed(260,nb);
  H8 <= conv_signed(-102,nb);
  H9 <= conv_signed(-52,nb);
  H10 <= conv_signed(-1,nb);

  process (CLK, RST_n)
    file fp_in : text open READ_MODE is "../src/samples.txt";
    variable line_in,line_in1,line_in2 : line;
    variable x, x1, x2 : integer;
  begin  -- process
    if RST_n = '0' then                 -- asynchronous reset (active low)
      DOUT <= (others => '0') after tco;
      DOUT1 <= (others => '0') after tco;
      DOUT2 <= (others => '0') after tco;
      VOUT <= '0' after tco;
      sEndSim <= '0' after tco;
    elsif CLK'event and CLK = '1' then  -- rising clock edge
      if not endfile(fp_in) then
		  --first
        readline(fp_in, line_in);
        read(line_in, x);
        DOUT <= conv_signed(x, nb) after tco;
		  --second
		  readline(fp_in, line_in1);
        read(line_in1, x1);
        DOUT1 <= conv_signed(x1, nb) after tco;
		  --third
		  readline(fp_in, line_in2);
        read(line_in2, x2);
        DOUT2 <= conv_signed(x2, nb) after tco;

        VOUT <= '1' after tco;
        sEndSim <= '0' after tco;

      else
        VOUT <= '0' after tco;        
        sEndSim <= '1' after tco;
      end if;
    end if;
  end process;

  process (CLK, RST_n)
  begin  -- process
    if RST_n = '0' then                 -- asynchronous reset (active low)
      END_SIM_i <= (others => '0') after tco;
    elsif CLK'event and CLK = '1' then  -- rising clock edge
      END_SIM_i(0) <= sEndSim after tco;
      END_SIM_i(1 to 10) <= END_SIM_i(0 to 9) after tco;
    end if;
  end process;

  END_SIM <= END_SIM_i(10);

end beh;
