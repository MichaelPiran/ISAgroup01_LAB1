library IEEE;
use IEEE.std_logic_1164.all; 
use ieee.numeric_std.all;
use WORK.fir_package.all;
entity REG16 is
	Port (REG_IN    :	In	signed(2*nb_opt-1 downto 0);
		   REG_EN    :	In	std_logic;
	      REG_CLK   :	In	std_logic;
         REG_RESET :	In	std_logic;
         REG_OUT   : Out signed(2*nb_opt-1 downto 0));
end REG16;

architecture behavior of REG16 is -- REGISTER flip flop D with syncronous reset
begin
	PSYNCH: process(REG_CLK,REG_RESET)
	begin
	  if REG_CLK'event and REG_CLK='1' then -- positive edge triggered:
	    if REG_RESET='0' then -- active low reset 
	      REG_OUT <= (others => '0'); 
	    else
		   if REG_EN = '1' then
	        REG_OUT <= REG_IN; -- input is written on output
			end if;
	    end if;
	  end if;
	end process;
end behavior;
