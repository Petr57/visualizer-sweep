#include <acc_I2C.h>

eeprom int x=0;

void main(void)
{
    char lol;
    acc_init(); 
    //DDRD=0x00;
    DDRB=0xff;
    //PORTD=0x00;
    PORTB=0x01;
    while(1)
    {    
        if(PORTB==0x80)
        {
            PORTB=0x01;
        }              
        else
        {   
            send_start();
            send_byte(adress<<1);
            lol=get_sak();    
            send_finish();
            PORTB |=(lol<<7);
            if(!lol)
                PORTB=PORTB<<1;
        }   
        delay_ms(1000);    
    } 
    x=0;
}