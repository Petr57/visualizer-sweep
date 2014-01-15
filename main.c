#include <sweep.h>


//extern char enable_update;
eeprom int x=0;
//eeprom char values[100]; 
//char i=0,j;

void main(void)
{   
    #asm("sei")      //set enable interrupts
    sweep_init();   
    /*    
    delay_ms(2000); 
    char level=0x08; 
    signed char temp; 
    char i;
    for(i=0;i<100;i++)
    {   
        values[i]=get_Y(); 
        delay_ms(10);   
    } 
    for(i=0;i<100;i++)
    {
        PORTB=values[i];
        delay_ms(2000);
    }*/  
    while(1)
    {                 
        try_update(); 
        /*     
        if(i==100)
        {
            for(j=0;j<100;j++)
            {
                PORTB=values[j];
                delay_ms(1000);
            }
        } 
        for(i=0;i<5;i++) temp[i]=acc_values[i];
        for(i=0;i<5;i++)
        {
            PORTB=temp[i];
            delay_ms(1000);
        }  
        PORTB=get_Y();
        delay_ms(50);   
        temp=get_X()/5;
        if(temp<0) temp=-temp; 
        PORTB=temp;  
            if(temp>0) 
                PORTB=level<<temp;
            else
                PORTB=level>>(-temp); */
        #asm("sleep")
        #asm("nop")              
    } 
    x=0;
}