/**
    ICT710 Project Assignment  
    main.cpp
    Purpose: Turn on/off Train lamp for Rails simulation.

    @author Ukrish Vanichrujee
    @version 1.0 4/26/2017
*/
#include "mbed.h"

DigitalOut led(LED1);// test led
DigitalOut led_red(D15);// red
DigitalOut led_yellow1(D11);// yellow1
DigitalOut led_yellow2(D14);// yellow2
DigitalOut led_green(D13);// green
RawSerial pc(USBTX, USBRX);

void lamp(char c){
    
    switch(c){
    
        case 'p':
            led_yellow2 = 1;
            led_yellow1 = 0;
            led_red = 0;
            led_green = 0;
            break;
        case 'y':
            led_yellow2 = 1;
            led_yellow1 = 1;
            led_red = 0;
            led_green = 0;
            break;
        case 'r':
            led_yellow2 = 0;
            led_yellow1 = 0;
            led_red = 1;
            led_green = 0;
            break;
        case 'g':
            led_yellow2 = 0;
            led_yellow1 = 0;
            led_red = 0;
            led_green = 1;
            break;
        case 'c':
            led_yellow2 = 0;
            led_yellow1 = 0;
            led_red = 0;
            led_green = 0;
            break;
    }
    
}
int main() {
    while(1){
        
        // Read Data from Python via serial 
        if (pc.readable()) {
            char ch = pc.getc();
            lamp(ch);
        }
        
    }
}
