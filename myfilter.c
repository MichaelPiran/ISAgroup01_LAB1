#include <stdio.h>
#include <stdlib.h>

#define NT 10 /// number of coeffs
#define NB 8 /// number of bits 13

///const int b[NT]={8, 17, 8}; /// b array
 int b[NT+1];///Definne b array to be read from file
///Read b from file Matlab

/// Perform fixed point filtering assming direct form I
///\param x is the new input sample
///\return the new output sample
int myfilter(int x)
{
  static int sx[NT+1]; /// x shift register
  static int sy[NT-1]; /// y shift register
  static int first_run = 0; /// for cleaning shift registers
  int i; /// index
  int y; /// output sample

  /// clean the buffers
  if (first_run == 0)
  {
    first_run = 1;
    for (i=0; i<NT+1; i++)
      sx[i] = 0;
    for (i=0; i<NT-1; i++)
      sy[i] = 0;
  }

  /// shift and insert new sample in x shift register
  for (i=NT; i>0; i--)
    sx[i] = sx[i-1];
  sx[0] = x;

  /// make the convolution
  /// Moving average part
  y = 0;
  for (i=0; i<NT+1; i++){
    y += (sx[i]*b[i]) >> (NB-1); // y=yq/(2^nb-1)
    //-1 <= y <= +1
    printf("tmp sum : %d = %d * %d\n", y, sx[i], b[i]);}
  printf("----------------------------------\n");
  /// update the y shift register
  for (i=NT-2; i>0; i--)
    sy[i] = sy[i-1];
  sy[0] = y;

  return y;
}

int main (int argc, char *argv[])
{
  FILE *fp_in;
  FILE *fp_out;
  FILE *fp_b;
  int x;
  int x_temp, y_temp, b_temp;
  int y, y1;

  /// check the command line
  if (argc != 3)
  {
    printf("Use: %s <input_file> <output_file>\n", argv[0]);
    exit(1);
  }
// Fill b array
  int i=0;
  fp_b = fopen("/home/isa01/Desktop/Csim/bcoeff.txt", "r"); 
  if (fp_b == NULL) {
    printf("Error open bcoeff.txt\n");
    exit(3);
  }
  while (!feof(fp_b)){
    fscanf(fp_b, "%d",&b_temp);
    b[i] = b_temp >>  5;
    //printf("b input: %d\n", b[i]);
    i++;
  }
  fclose(fp_b);
  /// open files
  fp_in = fopen(argv[1], "r");
  if (fp_in == NULL)
  {
    printf("Error: cannot open %s\n");
    exit(2);
  }

  fp_out = fopen(argv[2], "w");
  /// get samples and apply filter
  fscanf(fp_in, "%d", &x_temp);
  x = x_temp >> 5;
  do{
    y_temp = myfilter(x);
    y = y_temp << 5;
    fprintf(fp_out,"%d\n", y);
    fscanf(fp_in, "%d", &x_temp);
    //printf("x input: %d\n", x);
    x = x_temp >> 5;
  } while (!feof(fp_in));

  fclose(fp_in);
  fclose(fp_out);

  return 0;

}
