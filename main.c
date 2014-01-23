#include <sweep.h>

eeprom int x=0;

void main(void)
{   
    #asm("sei")      //set enable interrupts
    sweep_init();  
    delay_ms(2000); 
    while(1)
    {  
        sweep_update();
        delay_ms(5);
        #asm("sleep")
        #asm("nop")              
    } 
    x=0;
}