#include <sweep.h>
#include <lis331dl.h>

eeprom int x=0;

/*
interrupt [TIM1_OVF] void timer1_overflow(void)
{                                  
    PORTB ++;
}  */

void main(void)
{
/*
    char level=0x08; 
    signed char temp; */ 
    #asm("sei")      //set enable interrupts
    acc_init(); 
    DDRB=0xff; 
    sweep_init(); 
    while(1)
    {        
        /*
        temp=get_X()/5;    
        if(temp>0) 
            PORTB=level<<temp;
        else
            PORTB=level>>(-temp);
        delay_ms(25); */   
    } 
    x=0;
}