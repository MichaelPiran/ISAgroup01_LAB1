LIBRARY ieee;
use ieee.std_logic_vector.all;
use ieee.numeric_std.all;
use STD.textio.all;
use ieee.std_logic_textio.all;

PACKAGE fir_package is
  
  constant nb : integer := 8;--Number of bits
  constant N : integer := 10;--Number of elements
----------------------------------------------------------------
--Read Input files 
----------------------------------------------------------------
  file file_bcoeff  : text;--File pointer b coeff file
  file file_samples : text;--File pointer samples file
  
  process
  variable bcoeff_LINE  : line;--Line b coeff file
  variable samples_LINE : line;--Line samples file
  type file_vect_elm is array (N downto 0) of signed(nb-1 downto 0);
  variable b_coeff : file_vect_elm := (others =>(others =>'0'));
  variable v_X     : file_vect_elm := (others =>(others =>'0'));
  variable i,j : integer := '0';
  begin
  file_open(file_bcoeff, "samples.txt",  read_mode);
  file_open(file_samples, "bcoeff.txt", read_mode);
  --Read bcoeff file
  while not endfile(file_bcoeff) loop
    readline(file_bcoeff, bcoeff_LINE);
    read(bcoeff_LINE, b_coeff(i));
	 i <= i + 1;
  end loop;
  --Read samples file
  while not endfile(file_samples) loop
    readline(file_samples, samples_LINE);
    read(samples_LINE, v_X(j));
	 j <= j + 1;
  end loop; 
  file_close(file_bcoeff);
  file_close(file_samples);
  end process;
----------------------------------------------------------------
END PACKAGE;
