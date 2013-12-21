#include<progI2C.h>


void acc_init()
{
    ACCDDR |= (1<<ACCPOWER)|(1<<SCL)|(1<<SDA);   //SDA,SCL,POWER set out
    ACCPORT |= (1<<ACCPOWER)|(1<<SCL)|(1<<SDA);  //SDA,SCL,POWER set 1       
}

void send_start()
{
    ACCDDR |= (1<<SDA);         //SDA set out
    ACCPORT |= (1<<SDA);        //SDA=1
    ACCPORT |= (1<<SCL);        //SCL=1  
    ACCPORT &= ~(1<<SDA);       //SDA=0
    delay_us(hold_time);
}    

void repeat_start()
{
    ACCDDR |= (1<<SDA);         //SDA set out
    ACCPORT |= (1<<SDA);        //SDA=1
    ACCPORT |= (1<<SCL);        //SCL=1 
    delay_us(clock_hight); 
    ACCPORT &= ~(1<<SDA);       //SDA=0
    delay_us(hold_time);
}    

void send_byte(char message)
{
    char i;
    char mask=0b10000000; 
    ACCDDR |= (1<<SDA);         //SDA set out
    ACCPORT &= ~(1<<SCL);       //SCL=0   
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
    get_sak();
}

char get_byte()
{
    char i,temp=0x00; 
    ACCPORT &= ~(1<<SCL);       //SCL=0  
    ACCDDR &= ~(1<<SDA);        //SDA set in
    for(i=0;i<8;i++)
    {      
        ACCPORT |= (1<<SCL);        //SCL=1 
        temp = temp<<1;  
        delay_us(setup_time);
        temp |= ACCPIN&(1<<SDA);
        ACCPORT &= ~(1<<SCL);       //SCL=0 
        delay_us(hold_time);
    }
    return temp;
}

char get_sak()
{
    char temp;     
    ACCPORT &= ~(1<<SCL);       //SCL=0  
    ACCDDR &= ~(1<<SDA);        //SDA set in
    ACCPORT |= (1<<SDA);        //SDA=1  line supporter  
    ACCPORT |= (1<<SCL);        //SCL=1  
    delay_us(setup_time);
    temp=ACCPIN&(1<<SDA);
    ACCPORT &= ~(1<<SCL);       //SCL=0 
    delay_us(hold_time);  
    return temp;
}

void send_mak(char mode)
{   
    ACCDDR |= (1<<SDA);         //SDA set out
    ACCPORT &= ~(1<<SCL);       //SCL=0   
        if(mode)
            ACCPORT |= (1<<SDA); //SDA=1
        else
            ACCPORT &= ~(1<<SDA);//SDA=0
    delay_us(setup_time);
    ACCPORT |= (1<<SCL);    //SCL=1   
    delay_us(clock_hight);
    ACCPORT &= ~(1<<SCL);   //SCL=0
    delay_us(hold_time);  
}

void send_stop()
{      
    ACCDDR |= (1<<SDA);         //SDA set out
    ACCPORT &= ~(1<<SDA);       //SDA=0  
    ACCPORT |= (1<<SCL);        //SCL=1   
    delay_us(setup_time); 
    ACCPORT |= (1<<SDA);        //SDA=1
    delay_us(clock_hight);  
}