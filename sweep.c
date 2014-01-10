#include <sweep.h> 
 
char Frame[]={0x86,0x86,0xfe,0x86,0x86,0x86,0x7e,0x00}; //symbol A   
int periods_arr[8];
char line_pointer=0;
char dir=0;                 //0-up 1-down
int period=7800;

void sweep_init()
{   
    set_periods(period); 
    TCCR1B |=(1<<CS12);     //set prescale 256 on TIMER1   
    TIMSK |=(1<<OCIE1A)|(1<<OCIE1B);     //set enable Overflow and Compare A/B Match interrupts
    OCR1A=TCNT1+period;
    set_line();
}

void set_line()
{                    
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
    }
    PORTB=Frame[line_pointer];         
    OCR1B=TCNT1+periods_arr[line_pointer]; 
    if(dir)
        line_pointer--;
    else
        line_pointer++; 
}

void set_periods(int period)
{
    periods_arr[0]=(period/(int)4-period/(int)50);      //23%
    periods_arr[1]=(period/(int)8-period/(int)50);      //10,5%
    periods_arr[2]=(period/(int)11-period/(int)200);    //8,6% 
    periods_arr[3]=(period/(int)12-period/(int)300);    //8%
    periods_arr[4]=periods_arr[3];
    periods_arr[5]=periods_arr[2]; 
    periods_arr[6]=periods_arr[1];
    periods_arr[7]=periods_arr[0]; 
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

interrupt [TIM1_COMPA] void period_overflow(void)
{
/*      
    OCR1A=TCNT1+period;  
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
    set_line();   */
} 

interrupt [TIM1_COMPB] void line_overflow(void)
{
    set_line();
}