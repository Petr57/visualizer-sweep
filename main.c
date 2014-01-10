#include <lis331dl.h>
#include <tiny2313.h>

eeprom int x=0;
char Frame[]={0x86,0x86,0xfe,0x86,0x86,0x86,0x7e,0x00};
char dir=0;



interrupt [TIM1_OVF] void timer1_overflow(void)
{                                  
    PORTB ++;
}

void main(void)
{
    char level=0x08; 
    signed char temp;  
    #asm("sei")      //set enable interrupts
    acc_init(); 
    DDRB=0xff; 
    PORTB=1;  
    TCCR1B |=(1<<CS12);     //set prescale 256 on TIMER1   
    TIMSK |=(1<<TOIE1)|(1<<OCIE1A)|(1<<OCIE1B);     //set enable Overflow and Compare A/B Match interrupts
    while(1)
    {      
        delay_ms(1000);
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