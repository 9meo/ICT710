#include "mbed.h"
#include "commond.h"

void statusFcn()
{
    // setup
    while(1) {
        //loop
        osEvent evt = statusQueue.get();
        if(evt.status == osEventMessage) {
            message_t *msg = (message_t *)evt.value.p;
            switch (msg->command) {
                case 0x00:
                    message_t res;
                    res.destAddr = 0x00;
                    res.srcAddr = devices[2].id;
                    res.ctrl = 0x02;
                    res.command = 0x00;
                    res.arg = 0x00;
                    res.size = 0x02;
                    res.crc = res.ctrl + res.destAddr + res.srcAddr + res.command + res.arg + res.size;
                    //wait(0.1);
                    nodeQueue.put(&res);
                    break;
                case 0x01:
                    if(devices[2].status==0) {
                        devices[2].id=msg->arg;
                        devices[2].status=2;
                        message_t res;
                        res.destAddr = 0x00;
                        res.srcAddr = devices[2].id;
                        res.ctrl = 0x02;
                        res.command = msg->command;
                        res.arg = devices[2].id;
                        res.size = 0x02;
                        res.crc = res.ctrl + res.destAddr + res.srcAddr + res.command + res.arg + res.size;
                        //wait(0.1);
                        nodeQueue.put(&res);
                    } else {

                    }

                    break;

                case 0x02:
                    if(devices[2].status==2) {
                        res.destAddr = 0x00;
                        res.srcAddr = devices[2].id;
                        res.ctrl = 0x02;
                        res.command = devices[2].function >> 8;
                        res.arg = devices[2].function;
                        res.size = 0x02;
                        res.crc = res.ctrl + res.destAddr + res.srcAddr + res.command + res.arg + res.size;
                        //wait(0.1);
                        nodeQueue.put(&res);
                    } else {

                    }

                    break;

                case 0x03:
                    if(devices[2].status==2) {

                        res.destAddr = 0x00;
                        res.srcAddr = devices[2].id;
                        res.ctrl = 0x02;
                        res.command = msg->command;

                        res.arg =  devices[2].status;


                        res.size = 0x02;
                        res.crc = res.ctrl + res.destAddr + res.srcAddr + res.command + res.arg + res.size;
                        //wait(0.1);
                        nodeQueue.put(&res);
                    } else {

                    }

                    break;


            }
        }
    }
}