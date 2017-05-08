#include "mbed.h"
#include "commond.h"
DigitalOut Beep(D11);
bool stop=true;
void beep_onoff()
{
    while(1) {
        // loop
        //osEvent evt = Thread::signal_wait(0); // wait fot command
        //if (evt.value.signals & 0x01) {
        if(!stop) {
            Beep = 0;
            wait(0.5);
        }
        Beep = 1;
        wait(1);
        //}
        //if (evt.value.signals & 0x02) {
        //  Beep = 1;
        //}
    }
}
void alarmFcn()
{
    Beep = 1;
    Thread beepThread(osPriorityNormal, (DEFAULT_STACK_SIZE * 2.25), NULL);
    beepThread.start(beep_onoff);
    while(1) {
        //loop
        osEvent evt = alarmQueue.get();
        if(evt.status == osEventMessage) {
            message_t *msg = (message_t *)evt.value.p;
            switch (msg->command) {
                case 0x00:
                    message_t res;
                    res.destAddr = 0x00;
                    res.srcAddr = devices[3].id;
                    res.ctrl = 0x02;
                    res.command = 0x00;
                    res.arg = 0x00;
                    res.size = 0x02;
                    res.crc = res.ctrl + res.destAddr + res.srcAddr + res.command + res.arg + res.size;
                    nodeQueue.put(&res);
                    break;
                case 0x01:
                    if(devices[3].status==0) {
                        devices[3].id=msg->arg;
                        devices[3].status=2;
                        res.destAddr = 0x00;
                        res.srcAddr = devices[3].id;
                        res.ctrl = 0x02;
                        res.command = msg->command;
                        res.arg = devices[3].id;
                        res.size = 0x02;
                        res.crc = res.ctrl + res.destAddr + res.srcAddr + res.command + res.arg + res.size;
                        nodeQueue.put(&res);
                    } else {

                    }

                    break;

                case 0x02:
                    if(devices[3].status==2) {

                        res.destAddr = 0x00;
                        res.srcAddr = devices[3].id;
                        res.ctrl = 0x02;
                        res.command = devices[3].function >> 8;
                        res.arg = devices[3].function;
                        res.size = 0x02;
                        res.crc = res.ctrl + res.destAddr + res.srcAddr + res.command + res.arg + res.size;
                        nodeQueue.put(&res);
                    } else {

                    }

                    break;

                case 0x03:
                    if(devices[3].status==2) {
                        if(msg->arg == 0x01) {
                            stop = false;
                            
                            res.arg = 0x01;
                        } else {
                            Beep=1;
                            stop = true;
                             
                            res.arg = 0x00;
                        }
                        res.destAddr = 0x00;
                        res.srcAddr = devices[3].id;
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