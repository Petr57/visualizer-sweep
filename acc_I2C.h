#include <io.h>
#include <delay.h>
    //port setting                       
#define ACCPORT PORTD 
#define ACCPIN PIND                     
#define ACCDDR DDRD        
#define ACCPOWER 2    //power line
#define SCL 1         //clock line
#define SDA 0         //data line
#define adress 0b0011101    //accelerometer adress
    //I2C slave timing values in us      
#define hold_time 1
#define setup_time 1 
#define clock_low 5
#define clock_hight 4 

void acc_init();

void send_start();

void send_byte(char message);

char get_sak();

void send_finish();