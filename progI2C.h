#include <io.h>
#include <delay.h>

    //port setting                       
#define ACCPORT PORTD  //accelerometer out port
#define ACCPIN PIND    //accelerometer in port                  
#define ACCDDR DDRD    //accelerometer port mode   
#define ACCPOWER 2    //power line
#define SCL 1         //clock line
#define SDA 0         //data line

    //I2C slave timing values in us      
#define hold_time 1
#define setup_time 1 
#define clock_low 5
#define clock_hight 4 

//port initialization
void acc_init();

//set start on the bus
void send_start();

//repeat start on the bus
void repeat_start();

//send byte on the bus
void send_byte(char message);

//get byte on the bus
char get_byte();

//get slave acknowledge
char get_sak();

//send master acknowledge
void send_mak(char mode);

//set stop on the bus
void send_stop();