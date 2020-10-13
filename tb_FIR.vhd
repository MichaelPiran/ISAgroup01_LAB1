LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use WORK.fir_package.all;

ENTITY tb_FIR is
END tb_FIR;

ARCHITECTURE test OF tb_FIR is

type bit_mat is array (N-1 downto 0) of signed(nb-1 downto 0);

COMPONENT FIR is
  PORT(DIN : IN signed(nb-1 downto 0);
       VIN : IN std_logic;
       RST_n : IN std_logic;
       CLK : IN std_logic;
       DOUT : OUT signed(nb-1 downto 0);
       VOUT : OUT std_logic);
 END FIR;
 
 signal sig_CLK : std_logic;
 signal sig_RST_n : std_logic;
 signal sig_DIN : signed(nb-1 downto 0);
 signal wave_VIN : std_logic;
 
 BEGIN
 
tb_clock: process(sig_CLK)
  begin
    sig_CLK <= not(sig_CLK) after 50ns; --look here;
end process;
    
test : process
  begin
    
    

test_FIR : FIR PORT MAP
  (DIN => wave_DIN, VIN => wave_VIN, RST_n => wave_RST_n, CLK => wave_CLK);
 
END test;
