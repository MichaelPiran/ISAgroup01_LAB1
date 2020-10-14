LIBRARY ieee;
use ieee.std_logic_vector.all;
use ieee.numeric_std.all;
use STD.textio.all;
use ieee.std_logic_textio.all;

PACKAGE fir_package is

process
  constant nb : integer := 8;
  constant N : integer := 10;
  constant samples_num : integer := 200
    
  variable row : integer :=0; --useful to take track of the current file row

  variable v_line : line; --file object
  variable val : signed(nb-1 downto 0); --temporary variable useful to store x or b_coeff values while building data matrixes
    
  variable b_coeff : signed(nb-1 downto 0); --b coefficients
    
  type X_array is array (samples_num-1 downto 0) of signed(nb-1 downto 0);
  type b_coeff is array (N-1 donwto 0) of std_logic_vector(nb-1 downto 0);

begin
  
 --read all lines in the file and write the values in X_array
  file_open(file_samples, "samples.txt", read_mode); 

  while not endfile(file_samples) loop
    
    readline(file_samples, v_line);
    read(v_line, val);

    X_array(row) := val;

    row := row + 1; --next file row
    
  end loop;

  row := 0; --reset file row

  file_close(file_samples);


 --read all lines in the file and write the values in bcoeff array
  file_open(file_bcoeff, "bcoeff.txt", read_mode);

  while not endfile(file_bcoeff) loop
    
    readline(file_bcoeff, v_line);
    read(v_line, val);

    b_coeff(row) := val;

    row := row + 1; --next file row
    
  end loop;

  file_close(file_bcoeff);

  wait; --to avoid infinite computation in 0 time (allowed in PACKAGE)?
 end process;
END PACKAGE;
