#include <lis331dl.h>

char get_at_address(char reg_addr)
{
    char temp;
    send_start();
    send_byte(address<<1);
    send_byte(reg_addr); 
    repeat_start();
    send_byte((address<<1)+1);
    temp=get_byte();
    send_mak(1);   
    send_stop(); 
    return temp;
}

void set_at_address(char reg_addr, char data)
{   
    send_start();
    send_byte(address<<1);
    send_byte(reg_addr);  
    send_byte(data);
    send_stop();
}

void acc_init()
{
    I2C_init(); 
    delay_ms(10);
    set_at_address(CTRL_REG1,0b11100111); //set DR, PD, FS, Zen, Yen, Xen
}

signed char get_X()
{
    return get_at_address(OUT_X);
}
signed char get_Y()
{
    return get_at_address(OUT_Y);
} 
/*
signed char get_Z()
{
    return get_at_address(OUT_Z);
}   

axis_values get_axis_values()
{
    axis_values temp;
    temp.X=get_at_address(OUT_X);
    temp.Y=get_at_address(OUT_Y);
    temp.Z=get_at_address(OUT_Z);
    return temp;
}  */