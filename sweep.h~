#include <tiny2313.h>
#include <lis331dl.h>

#define FRAMEPORT PORTB

void sweep_init(void);

void set_line(void);

void set_periods(void);

void set_new_swing(void);

int check_inf(void);

void try_update(void);

interrupt [TIM1_COMPA] void period_overflow(void);

interrupt [TIM1_COMPB] void line_overflow(void);

interrupt [TIM0_OVF] void next_value(void);