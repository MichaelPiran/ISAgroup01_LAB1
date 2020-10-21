LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use WORK.fir_package.all;

entity FIR is
  PORT(DIN : IN signed(nb-1 downto 0);
		 H0 : in signed (nb-1 downto 0);
		 H1 : in signed (nb-1 downto 0);
		 H2 : in signed (nb-1 downto 0);
		 H3 : in signed (nb-1 downto 0);
		 H4 : in signed (nb-1 downto 0);
		 H5 : in signed (nb-1 downto 0);
		 H6 : in signed (nb-1 downto 0);
		 H7 : in signed (nb-1 downto 0);
		 H8 : in signed (nb-1 downto 0);
		 H9 : in signed (nb-1 downto 0);
		 H10 : in signed (nb-1 downto 0);
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
signal b_vect   : sig_vector := (others =>(others =>'0'));

begin
  b_vect(0) <= H0;
  b_vect(1) <= H1;
  b_vect(2) <= H2;
  b_vect(3) <= H3;
  b_vect(4) <= H4;
  b_vect(5) <= H5;
  b_vect(6) <= H6;
  b_vect(7) <= H7;
  b_vect(8) <= H8;
  b_vect(9) <= H9;
  b_vect(10)<= H10;
  FF_loop: for i in 0 to N-1 generate --10 registers that shift the input sample at each clock cycle
    FF_i : REG port map(REG_IN => op_mult(i), REG_EN => VIN, REG_CLK => CLK, REG_RESET => RST_n, REG_OUT => op_mult(i+1));
  end generate;

  process(CLK)
    variable sum     : signed(2*nb -1 downto 0) := (others => '0');
	 variable res_mult : signed(2*nb -1 downto 0):= (others => '0');
  begin 
    --when VIN=1 new sample is loaded into the architecture
    if (VIN = '1') then 
      op_mult(0) <= DIN;--New sample is store
		
		for i in 0 to N loop
        --res_mult(i) <= op_mult(i) * b_vect(i) ;--b_coefficients defined
                                               --in the  package
        --sum := sum + res_mult(i);--Final sum     
		  res_mult := op_mult(i) * b_vect(i) ;--b_coefficients defined
                                               --in the  package
        sum := sum + res_mult;--Final sum 
      end loop;
		VOUT <= '1'; --Dout is ready
		
	 else
	   VOUT <= '0';--Dout is not ready
	 end if;
	 
	 DOUT <= sum(nb-1 downto 0); --Result in output 
	 
  end process;
end architecture;
