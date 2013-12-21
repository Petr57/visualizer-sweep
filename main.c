#include <lis331dl.h>

eeprom int x=0;

void main(void)
{
    char level=0x08; 
    signed char temp;
    acc_init(); 
    DDRB=0xff; 
    PORTB=1;
    while(1)
    {   
        temp=get_X()/5;    
        if(temp>0) 
            PORTB=level<<temp;
        else
            PORTB=level>>(-temp);
        delay_ms(100);    
    } 
    x=0;
}