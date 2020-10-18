LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use WORK.fir_package.all;

entity FIR is
  PORT(DIN : IN signed(nb-1 downto 0);
       VIN : IN std_logic;
       RST_n : IN std_logic;
       CLK : IN std_logic;
       DOUT : OUT signed(nb-1 downto 0);
       VOUT : OUT std_logic );
end FIR; 

architecture BEHAVIOR of FIR is

component REG is
	Port (REG_IN    :	In	signed(nb-1 downto 0);
	      REG_EN    :	In	std_logic;
	      REG_CLK   :	In	std_logic;
         REG_RESET :	In	std_logic;
         REG_OUT   : Out signed(nb-1 downto 0));
end component;
  
type sig_vector is array (N downto 0) of signed(nb-1 downto 0);
signal op_mult  : sig_vector := (others =>(others =>'0'));  --Operand of multiplication
signal res_mult : sig_vector := (others =>(others =>'0')); --Result of multiplication 

begin
  
  FF_loop: for i in 0 to N-1 generate --10 registers that shift the input sample at each clock cycle
    FF_i : REG port map(REG_IN => op_mult(i), REG_EN => VIN, REG_CLK => CLK, REG_RESET => RST_n, REG_OUT => op_mult(i+1));
  end generate;

  process(CLK)
    
    variable sum     : signed(nb -1 downto 0);
    variable counter : signed(nb -1 downto 0);--To count the input samples
  begin 
    --when VIN=1 new sample is loaded into the architecture
    if (VIN = '1') then 
      op_mult(0) <= DIN;--New sample is store
		counter <= counter +	1;--Count how many samples are taken
	 end if;
    
    for i in 0 to N loop
      res_mult(i) <= op_mult(i) * b_coeff(i) ;--b_coefficients defined
                                              --in the  package
      sum <= sum + res_mult(i);--Final sum     
    end loop;
	 
    --when VOUT=1, output is ready
	 if (counter = to_signed(integer(N))) then 
      DOUT <= sum; --Result in output 
		VOUT <= '1'; --Result is ready
		sum <= '0';
	 end if;
	 
  end process;
end architecture;