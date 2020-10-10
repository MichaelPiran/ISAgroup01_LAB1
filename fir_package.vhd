LIBRARY ieee;
use ieee.std_logic_vector.all;
use ieee.numeric_std.all;

PACKAGE fir_package is
  
  generic(
    nb : signed(7 downto 0);
    N : std_logic
