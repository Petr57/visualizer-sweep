#include <tiny2313.h>
#include <delay.h> 

void sweep_init(void);

void set_line(void);

void set_periods(int period);

interrupt [TIM1_COMPA] void period_overflow(void);

interrupt [TIM1_COMPB] void line_overflow(void);