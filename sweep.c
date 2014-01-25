#include <sweep.h> 
 
__flash char Frame[]={0xf0,0x88,0x8c,0x88,0xf0,0x88,0x88,0xf0}; //symbol B //{0x01,0x02,0x04,0x08,0x10,0x20,0x40,0x80};//{0x86,0x86,0xfe,0x86,0x86,0x86,0x7e,0x00}; //symbol A

extern char next_symbol;
          
char line_pointer=0;
char dir=0;                 //0-up 1-down

char enable_update=0;               //permission to update the acceleration data
char enable_check=0;                //permission to processing acceleration data
unsigned int last_inf_time=0;
signed char last_value=0;
int last_time,more_last_time;
char dir_counter=1;  //0 - negative direction=1; 2 - positive direction=0;

unsigned int periods_arr[8];
unsigned int period=7800;   //time of one swing

void sweep_init()
{      
    acc_init(); 
    DDRB=0xff;              //set output portB
    set_periods();
    TCCR0B |=(1<<CS02);     //set prescale 256 on TIMER0  
    TCCR1B |=(1<<CS12);     //set prescale 256 on TIMER1   
    TIMSK |=(1<<OCIE1A)|(1<<OCIE1B)|(1<<TOIE1)|(1<<TOIE0);     //set enable Compare A/B Match interrupts on TIMER1 and Overflows
    
    OCR0A=128;
    OCR1A=TCNT1+period;
    set_line();
}

void set_line()
{  
    if(dir)
        FRAMEPORT=0x00;//Frame[7-line_pointer];          //set output line
    else
        FRAMEPORT=Frame[line_pointer];          
    OCR1B=TCNT1+periods_arr[line_pointer];      //set time for line
    if(line_pointer<7) line_pointer++;
}

void set_periods()     //set periods of lines
{
    periods_arr[0]=(period/(int)4-period/(int)50);      //23%
    periods_arr[1]=(period/(int)8-period/(int)50);      //10,5%
    periods_arr[2]=(period/(int)11-period/(int)200);    //8,6% 
    periods_arr[3]=(period/(int)12-period/(int)300);    //8%
    periods_arr[4]=periods_arr[3];
    periods_arr[5]=periods_arr[2]; 
    periods_arr[6]=periods_arr[1];
    periods_arr[7]=period;    
}

void set_new_swing()
{
    period=more_last_time-last_inf_time;  
    set_periods();
    enable_check=0; 
    line_pointer=0;
    TCNT1=more_last_time; //back to the past: set inf time  
    last_inf_time=TCNT1; 
    OCR1A=TCNT1+period/2;  
    set_line();
}

int check_inf(signed char value)
{
    if((value>last_value)&&(dir_counter<2))     dir_counter++;  //value rising -> dir_counter++
    if((value<last_value)&&(dir_counter>0))     dir_counter--;  //value falling -> dir_counter-- 
    
    if(dir)
    {
        if(dir_counter>1)
        {   
            dir=0;      //change direction
            return 1;
        }        
    } 
    else
    {
        if(dir_counter<1)
        {   
            dir=1;      //change direction
            return 1;
        }
    } 
    last_value=value;
    more_last_time=last_time;
    last_time=TCNT1;
    return 0;
}

void try_update()
{
    if(enable_update&&enable_check)
    { 
        enable_update=0;  
        if(check_inf(get_Y()))
            set_new_swing();           
    }
}

interrupt [TIM1_COMPA] void period_overflow(void)
{ 
    enable_check=1; 
} 

interrupt [TIM1_COMPB] void line_overflow(void)
{
    set_line();
}

interrupt [TIM0_OVF] void next_value(void)        //~120 OVF per second
{
    enable_update=1;
}

interrupt [TIM1_OVF] void next_sym(void)        //~0.5 OVF per second
{
    next_symbol=1;
}