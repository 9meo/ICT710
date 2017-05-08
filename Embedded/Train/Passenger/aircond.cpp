#include "mbed.h"
#include "commond.h"
DigitalOut ledAirGreen(D12);
DigitalOut ledAirRed(D10);
void airconFcn()
{
    // setup
    while(1) {
        //loop
        osEvent evt = airconQueue.get();
        if(evt.status == osEventMessage) {
            message_t *msg = (message_t *)evt.value.p;
            switch (msg->command) {
                case 0x00:
                    message_t res;
                    res.destAddr = 0x00;
                    res.srcAddr = devices[1].id;
                    res.ctrl = 0x02;
                    res.command = 0x00;
                    res.arg = 0x00;
                    res.size = 0x02;
                    res.crc = res.ctrl + res.destAddr + res.srcAddr + res.command + res.arg + res.size;
                    nodeQueue.put(&res);
                    //pc.printf("Re1:%d\n\r",devices[1].id);
                    break;
                case 0x01:
                    if(devices[1].status==0) {
                        devices[1].id=msg->arg;
                        devices[1].status=2;
                       // pc.printf("Res:%d\n\r",devices[1].id);
                        res.destAddr = 0x00;
                        res.srcAddr = devices[1].id;
                        res.ctrl = 0x02;
                        res.command = msg->command;
                        res.arg = devices[1].id;
                        res.size = 0x02;
                        res.crc = res.ctrl + res.destAddr + res.srcAddr + res.command + res.arg + res.size;
                        ledAirRed=1;
                        nodeQueue.put(&res);
                    } else {

                    }

                    break;
                case 0x02:
                    if(devices[1].status==2) {

                        res.destAddr = 0x00;
                        res.srcAddr = devices[1].id;
                        res.ctrl = 0x02;
                        res.command = devices[1].function >> 8;
                        res.arg = devices[1].function;
                        res.size = 0x02;
                        res.crc = res.ctrl + res.destAddr + res.srcAddr + res.command + res.arg + res.size;
                        nodeQueue.put(&res);
                    } else {

                    }

                    break;

                case 0x03:
                    if(devices[1].status==2) {
                        if(msg->arg == 0x01) {
                            //led1 = 1;
                            ledAirGreen=1;
                            ledAirRed=0;
                            //beepThread.start(beep_onoff);
                            res.arg = 0x01;
                        } else {
                            //led1 = 0;
                            ledAirGreen=0;
                            ledAirRed=1;
                            res.arg = 0x00;
                        }
                        res.destAddr = 0x00;
                        res.srcAddr = devices[1].id;
                        res.ctrl = 0x02;
                        res.command = msg->command;



                        res.size = 0x02;
                        res.crc = res.ctrl + res.destAddr + res.srcAddr + res.command + res.arg + res.size;
                        nodeQueue.put(&res);
                    } else {

                    }

                    break;

            }
        }
    }
}