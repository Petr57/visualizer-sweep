#include <io.h>
#include <delay.h>

void main(void)
{
    DDRD=0x00;
    DDRB=0xff;
    PORTB=0x80; 
    while(1)
    {   
        if(PORTB==0x01)
        {
            PORTB=0x80;
        }              
        else
        {
            PORTB/=2;
        }
        delay_ms(300);
    }  
}