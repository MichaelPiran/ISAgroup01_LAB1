LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
/*use ieee.math.all;*/
use WORK.fir_package.all;

entity FIR is
  PORT(DIN : IN signed(nb-1 downto 0);
       VIN : IN std_logic;
       RST_n : IN std_logic;
       CLK : IN std_logic;
       DOUT : OUT signed(nb-1 downto 0);
       VOUT : OUT std_logic );
end FIR; 

component REG is
	Port (REG_IN:	In	std_logic;
			REG_CLK:		In	std_logic;
			REG_RESET:	In	std_logic;
			REG_OUT: Out std_logic);
end component;

architecture BEHAVIOR of FIR is
type sig_vector is array (10 downto 0) of std_logic_vector(12 downto 0);
signal var: sig_vector:= (others =>'0')(others =>'0');
begin
  FF_loop: for i in 0 to 9 generate 
    FF_i : REG port map(REG_IN => , REG_CLK => CLK, REG_RESET => RST_n, REG_OUT => );
  end generate;
	 
  process(CLK)
  begin 
    s0 = x *a0;
    for 1 to 10
      
      mulres[i] =out*a;
	   si = s0+mulres[i];
	 end for;
  end process;
end architecture;

