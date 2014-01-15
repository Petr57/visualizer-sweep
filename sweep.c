#include <sweep.h> 
 
__flash char Frame[]={0x01,0x02,0x04,0x08,0x10,0x20,0x40,0x80};//{0x86,0x86,0xfe,0x86,0x86,0x86,0x7e,0x00}; //symbol A 
//extern eeprom char values[100];
//extern char i;
          
char line_pointer=0;
char dir=0;                 //0-up 1-down

char enable_update=0;
char enable_check=0;
unsigned int last_inf_time=0;
signed char acc_values[5];
char pointer=0;

unsigned int periods_arr[8];
unsigned int period=7800;   //time of one swing

void sweep_init()
{      
    acc_init(); 
    DDRB=0xff;              //set output portB
    set_periods();
    TCCR0B |=(1<<CS02);     //set prescale 256 on TIMER0  
    TCCR1B |=(1<<CS12);     //set prescale 256 on TIMER1   
    TIMSK |=(1<<OCIE1A)|(1<<OCIE1B)|(1<<OCIE0A)|(1<<TOIE0);     //set enable Compare A/B Match interrupts on TIMER1 and Overflow on TIMER0
    
    OCR0A=64;
    OCR1A=TCNT1+period;
    set_line();
}

void set_line()
{  /*                  
    if(line_pointer>7||line_pointer<0)
    { 
        if(dir)
        {   
            dir=0;
            line_pointer=0;
        }
        else  
        {     
            dir=1;
            line_pointer=7; 
        }
    }          */
    if(dir)
        FRAMEPORT=Frame[line_pointer];          //set output line
    else
        FRAMEPORT=Frame[7-line_pointer];          
    OCR1B=TCNT1+periods_arr[line_pointer];      //set time for line
    if(line_pointer<7) line_pointer++;
}

void set_periods()
{
    periods_arr[0]=(period/(int)4-period/(int)50);      //23%
    periods_arr[1]=(period/(int)8-period/(int)50);      //10,5%
    periods_arr[2]=(period/(int)11-period/(int)200);    //8,6% 
    periods_arr[3]=(period/(int)12-period/(int)300);    //8%
    periods_arr[4]=periods_arr[3];
    periods_arr[5]=periods_arr[2]; 
    periods_arr[6]=periods_arr[1];
    periods_arr[7]=period; 
    /*for(;line_pointer<8;line_pointer++) 
    {
        PORTB=line_pointer;
        delay_ms(2000);
        PORTB=periods_arr[line_pointer];
        delay_ms(5000);
        PORTB=(periods_arr[line_pointer])>>8;   
        delay_ms(5000);         
    }*/    
}

void set_new_swing()
{
    period=TCNT1-last_inf_time; 
    OCR1A=TCNT1+period-period/5;  
    set_periods();
    last_inf_time=TCNT1; 
    enable_check=0; 
    if(dir)
        dir=0;
    else
        dir=1; 
    line_pointer=0; 
    //PORTB=period>>8;
    //set_line();
}

int check_inf()
{
    if(dir)
    {   
        if((acc_values[(pointer+4)%5]>acc_values[(pointer+3)%5])&&(acc_values[(pointer+3)%5]<acc_values[(pointer+2)%5]))
        {
            return 1;
        }
    }  
    else
    {   
        if((acc_values[(pointer+4)%5]<acc_values[(pointer+3)%5])&&(acc_values[(pointer+3)%5]>acc_values[(pointer+2)%5]))
        {
            return 1;
        }
    }
    return 0;
}

void try_update()
{
    if(enable_update)
    { 
        enable_update=0;  
        acc_values[pointer]=get_Y(); 
        //if(i<100) values[i++]=acc_values[pointer];
        pointer=(pointer+1)%5;
        if(enable_check&&check_inf())
            set_new_swing(); 
           
    }
}

interrupt [TIM1_COMPA] void period_overflow(void)
{ 
    enable_check=1; 
/*
    OCR1A=TCNT1+period;  
    if(dir)
        dir=0;
    else
        dir=1; 
    line_pointer=0;
    set_line(); */  
} 

interrupt [TIM1_COMPB] void line_overflow(void)
{
    set_line();
}

interrupt [TIM0_OVF] void next_value(void)
{
    enable_update=1;
}

interrupt [TIM0_COMPA] void next_value2(void)
{
    enable_update=1;
}