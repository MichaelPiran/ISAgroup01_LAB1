library IEEE;
use IEEE.std_logic_1164.all; 

entity REG is
	Port (REG_IN:	In	std_logic;
			REG_CLK:		In	std_logic;
			REG_RESET:	In	std_logic;
			REG_OUT: Out std_logic);
end REG;

architecture REGSYNCH of REG is -- REGISTER flip flop D with syncronous reset
begin
	PSYNCH: process(REG_CLK,REG_RESET)
	begin
	  if REG_CLK'event and REG_CLK='1' then -- positive edge triggered:
	    if REG_RESET='1' then -- active high reset 
	      REG_OUT <= '0'; 
	    else
	      REG_OUT <= REG_IN; -- input is written on output
	    end if;
	  end if;
	end process;
end REGSYNCH;