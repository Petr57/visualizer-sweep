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
