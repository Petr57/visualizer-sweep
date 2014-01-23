#include <sweep.h> 
 
__flash char Frame[]={0xf0,0x88,0x8c,0x88,0xf0,0x88,0x88,0xf0}; //symbol B //{0x01,0x02,0x04,0x08,0x10,0x20,0x40,0x80};//{0x86,0x86,0xfe,0x86,0x86,0x86,0x7e,0x00}; //symbol A

signed char last_min=0,last_max=0,last_value=0;
char direction,line_pointer,dir_counter=2;  //0,1 - negative direction dir=1; 2,3 - positive direction dir=0;

void sweep_init()
{      
    acc_init(); 
    DDRB=0xff;              //set output portB
}

void set_line()
{  
    if(direction)
        FRAMEPORT=Frame[7-line_pointer];          //set output line
    else        
        FRAMEPORT=Frame[line_pointer];  
}

void sweep_update(void)
{
    signed char value,line_width;
    value=get_Y();
    if(value<last_min) last_min=value;
    if(value>last_max) last_max=value;
    if((value>last_value)&&(dir_counter<3))     dir_counter++;  //value rising -> dir_counter++
    if((value<last_value)&&(dir_counter>0))     dir_counter--;  //value falling -> dir_counter--  
    
    line_width=(last_max-last_min)/8;
    if(direction)
    { 
        if(dir_counter>1)
        {
            direction=0;
            last_min=value;
            line_pointer=0;
        }
        if(value<last_max-line_width*(line_pointer+1))
        {
            set_line();
        }
    }
    else
    {
        if(dir_counter<2)
        {
            direction=1;
            last_max=value;
            line_pointer=0;
        }
        if(value>last_min+line_width*(line_pointer+1))
        {
            set_line();
        }
    }
}

