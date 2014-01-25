#include <progI2C.h>    

#define address 0b0011101    //accelerometer adress
#define CTRL_REG1 0x20
#define CTRL_REG2 0x21
#define CTRL_REG3 0x22
#define OUT_X 0x29
#define OUT_Y 0x2B
#define OUT_Z 0x2D
/*
typedef struct{
    signed char X;
    signed char Y;
    signed char Z;
}axis_values;
*/
void acc_init();

char get_at_address(char reg_addr);

void set_at_address(char reg_addr, char data);
                                
signed char get_X();

signed char get_Y();
     
/*        unused functions
signed char get_Z(); 

axis_values get_axis_values(); */