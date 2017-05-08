#include "mbed.h"
#include "commond.h"
#include "time.h"

DigitalOut led1(LED1);
RawSerial pc(USBTX, USBRX);
RawSerial forward(D8, D2);
RawSerial backward(PA_11, PA_12);

//message_t *tmp;

Thread nodeDevice;
Thread airconDevice;
Thread lightDevice;
Thread alarmDevice;
Thread doorDevice;

Queue<message_t, 10> lightingQueue;
Queue<message_t, 10> airconQueue;
Queue<message_t, 10> doorQueue;
Queue<message_t, 10> alarmQueue;
Queue<message_t, 10> nodeQueue;

device devices[4];

void flushSerialBuffer(RawSerial device)
{
    char char1 = 0;
    while (device.readable()) {
        char1 = device.getc();
    }
    return;
}


void reply_msg(message_t *msg)
{
    backward.putc(STARTMSG);
    backward.putc(msg->destAddr);
    backward.putc(msg->srcAddr);
    backward.putc(msg->ctrl);
    backward.putc(msg->size);
    backward.putc(msg->command);
    backward.putc(msg->arg);
    backward.putc(msg->crc);
    //flushSerialBuffer(backward);
}
void forward_msg(message_t *msg)
{
    //flushSerialBuffer(backward);
    wait(0.05);
    forward.putc(STARTMSG);
    forward.putc(msg->destAddr);
    forward.putc(msg->srcAddr);
    forward.putc(msg->ctrl);
    forward.putc(msg->size);
    forward.putc(msg->command);
    forward.putc(msg->arg);
    forward.putc(msg->size);
    forward.putc(msg->crc);
    //flushSerialBuffer(forward);
}

void nodeFcn()
{
    //setup
    while(1) {
        //loop
        osEvent evt = nodeQueue.get();
        if(evt.status == osEventMessage) {
            message_t *msg = (message_t *)evt.value.p;
            if(msg->destAddr == 0xFF) {
                lightingQueue.put(msg);
                airconQueue.put(msg);
                doorQueue.put(msg);
                alarmQueue.put(msg);
                forward_msg(msg);
                //pc.printf("OK\n\r");
            } else if(msg->destAddr == 0x00) {


                reply_msg(msg);
               // pc.printf("source id: %x\n\r",msg->srcAddr);

            } else {
                bool inlist = false;
                for(int i=0; i<NUMDEVICES; i++) {
                    if(devices[i].id == msg->destAddr) {
                        devices[i].q->put(msg);
                        inlist = true;
                        pc.putc('d');
                    }
                }
                if(!inlist) {
                    forward_msg(msg);
                    pc.putc('e');
                }
            }

        }
    }
}
void init()
{
    //srand(time(NULL));
    devices[0].id = 0x30;//(rand()%64);
    //pc.printf("ID:%d\n\r",devices[0].id);
    devices[0].status = 0;
    devices[0].function = 0x0100;
    devices[0].q = &lightingQueue;

    devices[1].id = 0x31;//(rand()%64);
    devices[1].status = 0;
    devices[1].function = 0x0200;
    devices[1].q = &airconQueue;
    //pc.printf("ID:%d\n\r",devices[1].id);

    devices[2].id = 0x32;//(rand()%64);
    devices[2].status = 0;
    devices[2].function = 0x0300;
    devices[2].q = &doorQueue;
    //pc.printf("ID:%d\n\r",devices[2].id);

    devices[3].id = 0x33;//(rand()%64);
    devices[3].status = 0;
    devices[3].function = 0x0400;
    devices[3].q = &alarmQueue;
    //pc.printf("ID:%d\n\r",devices[3].id);
}

void backward_listen()
{
    static int index = 0;
    char ch = backward.getc();
    static message_t msg;

    switch (index) {
        case 0:
            if (ch == STARTMSG)
                index++;
            break;
        case 1:
            //Destination
            msg.destAddr = ch;
            index++;
            break;
        case 2:
            //Source
            msg.srcAddr = ch;

            index++;
            break;
        case 3:
            //Link Control
            msg.ctrl = ch;
            index++;
            break;
        case 4:
            //Size
            msg.size = ch;

            index++;
            break;
        case 5:
            //Command
            msg.command = ch; // << 8;
            //nodeQueue.put(&msg);
            index++;
            break;
        case 6:
            //Arguement
            msg.arg = ch;
            //nodeQueue.put(&msg);

            index++;
            break;
        case 7:
            //CRC
            msg.crc = ch;
            
            nodeQueue.put(&msg);
            index=0;
            break;
        default:
            index =0;
    }
}
void forward_listen()
{
    static int index = 0;
    char ch = forward.getc();
    static message_t msg;
    
    switch (index) {
        case 0:
            if (ch == STARTMSG)
                index++;
            //tmp = (message_t *) malloc(sizeof(message_t));  
            break;
        case 1:
            //Destination
            msg.destAddr = ch;
            //tmp->destAddr = ch;
            index++;
            break;
        case 2:
            //Source
            msg.srcAddr = ch;
            //tmp->srcAddr = ch;
            index++;
            break;
        case 3:
            //Link Control
            msg.ctrl = ch;
            //tmp->ctrl = ch;
            index++;
            break;
        case 4:
            //Size
            msg.size = ch;
            //tmp->size = ch;

            index++;
            break;
        case 5:
            //Command
            msg.command = ch; // << 8;
            //nodeQueue.put(&msg);
            //tmp->command = ch;
            index++;
            break;
        case 6:
            //Arguement
            msg.arg = ch;
            //nodeQueue.put(&msg);
            //tmp->arg = ch;
            index++;
            break;
        case 7:
            //CRC
            msg.crc = ch;
            //message_t tmp;
            //tmp.srcAddr = msg.srcAddr;
            nodeQueue.put(&msg);
            
            index=0;
            break;
        default:
            index =0;
    }
}
int main()
{
    init();

    lightDevice.start(lightingFcn);
    airconDevice.start(airconFcn);
    alarmDevice.start(alarmFcn);
    doorDevice.start(doorFcn);
    nodeDevice.start(nodeFcn);


    // message_t msg;
//    msg.destAddr = 0xFF;
//    msg.srcAddr = 0x00;
//    msg.ctrl = 0x00;
//    msg.command = 0x00;
//    msg.arg = 0;
//    msg.size = 0x01;
//    nodeQueue.put(&msg);

    forward.attach(forward_listen, Serial::RxIrq);
    backward.attach(backward_listen, Serial::RxIrq);
    while (true) {
        //led1 = !led1;
        wait(0.5);
    }
}

