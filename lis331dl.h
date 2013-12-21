#include <progI2C.h>    

#define address 0b0011101    //accelerometer adress

char get_at_address(char reg_addr);

void set_at_address(char reg_addr, char data);