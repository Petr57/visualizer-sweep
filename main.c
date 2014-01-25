#include <sweep.h>

eeprom int x=0;
char next_symbol=0;

void main(void)
{   
    #asm("sei")      //set enable interrupts
    sweep_init();   
    while(1)
    {  
        try_update();
        #asm("sleep")
        #asm("nop")              
    } 
    x=0;
}