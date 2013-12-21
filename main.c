#include <acc_I2C.h>

eeprom int x=0;

void main(void)
{
    char lol;  
    char y_adress=0x0F;
    acc_init(); 
    //DDRD=0x00;
    DDRB=0xff;
    //PORTD=0x00;
    PORTB=0x01;
    while(1)
    {                   
        send_start();
        send_byte(adress<<1);
        lol=get_sak();
        send_byte(y_adress); 
        lol=get_sak();
        repeat_start();
        send_byte((adress<<1)+1);   
        lol=get_sak();
        PORTB=get_byte();
        send_mak(0);   
        send_stop();   
        
        delay_ms(10);    
    } 
    x=0;
}