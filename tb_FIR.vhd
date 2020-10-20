LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use WORK.fir_package.all;
use STD.textio.all;
use ieee.std_logic_textio.all;

ENTITY tb_FIR is
END tb_FIR;

ARCHITECTURE test OF tb_FIR is

COMPONENT FIR is
  PORT(DIN : IN signed(nb-1 downto 0);
       VIN : IN std_logic;
       RST_n : IN std_logic;
       CLK : IN std_logic;
       DOUT : OUT signed(nb-1 downto 0);
       VOUT : OUT std_logic);
 END FIR;
  
 type X_array is array (N-1 downto 0) of signed(nb-1 downto 0);
 
 signal sig_CLK : std_logic := 0;
 signal sig_RST_n : std_logic := 0;
 signal sig_DIN : signed(nb-1 downto 0);
 signal wave_VIN : std_logic := 1;

 file file_res : text;
 
 BEGIN
   
X_array <= LUT_to_samples; 
 
tb_clock: process(sig_CLK) --process that simulates a clock
  begin
    sig_CLK <= not(sig_CLK) after 40ns; --look here;
end process;
    
TB_proc : process(sig_CLK) 
 
  --variable v_LINE : line; --file object
  --variable v_X : signed(nb-1 downto 0); --variable X
  --variable clk_count : integer := 0;
  
  begin
  
  if rising_edge(sig_CLK) then --sensitive to rising edge of the clock
    
   clk_count := clk_count + 1;
    
   --file_open(file_res, "filename.txt", read_mode); --read file (GIVE THE FILE A NAME)
  
 --read all lines in the files and write the values in sig_DIN
  --while not endfile(file_res) loop --THIS READS EVERY CLOCK CYCLE?
    --readline(file_res, v_LINE);
    --read(v_LINE, v_X);

    sig_DIN <= X_array(clk_count); --at every clock cycle give to the input a new value (x[n]) (X_array from FIR_package
  
 -- end loop;

  if(clk_count < 2) then --VIN=0 until 3 clk cycle
    VIN <= '0';
  else 
    VIN <= '1';
  end if;
    
  if(clk_count == 19) then --RST_n=1 @ 20th clk cycle
    RST_n <= '1';
  else
    RST_n <= '0':
  end if;

 end if;
end process; 
--NOTE: signals will be updated only at the end of the process and the new value will be visible only in the next clock cycle
    

test_FIR : FIR PORT MAP
  (DIN => wave_DIN, VIN => wave_VIN, RST_n => wave_RST_n, CLK => wave_CLK);
 
END test;
