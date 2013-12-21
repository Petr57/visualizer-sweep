#include"acc_I2C.h"


void acc_init()
{
    ACCDDR |= (1<<ACCPOWER)|(1<<SCL)|(1<<SDA); 
    ACCPORT |= (1<<ACCPOWER)|(1<<SCL)|(1<<SDA);          
}

void send_start()
{
    ACCDDR |= (1<<SDA); 
    ACCPORT |= (1<<SCL);        //SCL=1  
    delay_us(clock_hight);
    ACCPORT &= ~(1<<SDA);       //SDA=0
    delay_us(hold_time);
}

void send_byte(char message)
{
    char i;
    char mask=0b10000000; 
    ACCDDR |= (1<<SDA);
    ACCPORT &= ~(1<<SCL);       //SCL=0   
    delay_us(clock_low);
    ACCPORT &= ~(1<<SDA);       //SDA=0
    delay_us(clock_low);
    for(i=0;i<8;i++)
    {             
        if(message&mask)
            ACCPORT |= (1<<SDA); //SDA=1
        else
            ACCPORT &= ~(1<<SDA);//SDA=0
        mask=mask>>1;       //enough time for setup
        //delay_us(setup_time);
        ACCPORT |= (1<<SCL);    //SCL=1   
        delay_us(clock_hight);
        ACCPORT &= ~(1<<SCL);   //SCL=0
        delay_us(hold_time);          
    }
}

char get_sak()
{
    char temp; 
    ACCPORT &= ~(1<<SDA);       //SDA=0
    ACCDDR &= ~(1<<SDA);
    ACCPORT &= ~(1<<SDA);       //SDA=0 
    ACCPORT &= ~(1<<SCL);       //SCL=0  
    delay_us(clock_low);
    ACCPORT |= (1<<SCL);        //SCL=1   
    delay_us(clock_hight);
    temp=ACCPIN&(1<<SDA);
    ACCPORT &= ~(1<<SCL);       //SCL=0 
    delay_us(hold_time);  
    return temp;
}

void send_finish()
{      
    ACCDDR |= (1<<SDA);
    ACCPORT &= ~(1<<SDA);       //SDA=0  
    ACCPORT |= (1<<SCL);        //SCL=1   
    delay_us(setup_time); 
    ACCPORT |= (1<<SDA); //SDA=1
    delay_us(hold_time);  
}