LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use ieee.math.all;
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
	Port (REG_IN:	In	std_logic_vector(nb-1 downto 0);
	      REG_CLK:		In	std_logic;
              REG_RESET:	In	std_logic;
              REG_OUT: Out std_logic_vector(nb-1 downto 0));
end component;

architecture BEHAVIOR of FIR is
  
type sig_vector is array (N-1 downto 0) of std_logic_vector(nb-1 downto 0);
signal op_mult : sig_vector:= (others =>'0')(others =>'0');  --Operand of multiplication
signal res_mult : sig_vector:= (others =>'0')(others =>'0'); --Result of multiplication

signal b_coeff : sig_vector:= (others =>'0')(others =>'0');

begin

b_coeff <= LUT_to_bcoeff;
  
  FF_loop: for i in 0 to N-1 generate --10 registers that shift the input sample at each clock cycle
    FF_i : REG port map(REG_IN => op_mult[i], REG_CLK => CLK, REG_RESET => RST_n, REG_OUT => op_mult[i+1]);
  end generate;

  process(CLK)
    
    variable sum : std_logic_vector(nb -1 downto 0);

  begin 

    op_mult(0) <= DIN;--New sample is store
    
    for i in 0 to N loop
      res_mult(i) <= op_mult(i) * b_coeff(i) ;--b_coefficients defined
                                              --in the  package
      sum <= sum + res_mult(i);     
    end loop;

    DOUT <= sum;      --Result in output 
	 
  end process;
end architecture;
