LIBRARY ieee;
use ieee.std_logic_vector.all;
use ieee.numeric_std.all;

PACKAGE fir_package is
  
  constant nb : integer := 8;
  constant N : integer := 10;
  type b_coefficients is array (9 downto 0) of signed (7 downto 0); 
  signal b_coeff : b_coefficients := ...; --we need to initialize this

END PACKAGE;
