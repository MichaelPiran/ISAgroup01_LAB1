library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;
use WORK.fir_package.all;

library std;
use std.textio.all;

entity data_sink is
  port (
    CLK   : in std_logic;
    RST_n : in std_logic;
    VIN   : in std_logic;
    DIN   : in std_logic_vector(nb-1 downto 0);
	DIN1  : in std_logic_vector(nb-1 downto 0);
	DIN2  : in std_logic_vector(nb-1 downto 0));
end data_sink;

architecture beh of data_sink is

begin  -- beh

  process (CLK, RST_n)
    file res_fp : text open WRITE_MODE is "../src/results_place_route.txt";
    variable line_out, line_out1, line_out2 : line;
  begin  -- process
    if RST_n = '0' then                 -- asynchronous reset (active low)
      null;
    elsif CLK'event and CLK = '1' then  -- rising clock edge
      if (VIN = '1') then
		  --first
        write(line_out, conv_integer(signed(DIN)));
        writeline(res_fp, line_out);
		  --second
		write(line_out1, conv_integer(signed(DIN1)));
        writeline(res_fp, line_out1);
		  --third
		write(line_out2, conv_integer(signed(DIN2)));
        writeline(res_fp, line_out2);
      end if;
    end if;
  end process;

end beh;
