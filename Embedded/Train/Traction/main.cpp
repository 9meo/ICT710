#include "mbed.h"
#include "commond.h"
#include "Nunchuk.h"
DigitalOut led1(LED1);
RawSerial pc(USBTX, USBRX);
RawSerial forward(D8, D2);
I2C i2c(D14, D15);
Nunchuk * nc;
int position;

Thread powerDevice;
Thread brakeDevice;
Thread statusDevice;
Thread alarmDevice;
Thread nodeDevice;
Thread controlDevice;

Queue<message_t, 10> powerQueue;
Queue<message_t, 10> brakeQueue;
Queue<message_t, 10> alarmQueue;
Queue<message_t, 10> statusQueue;
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
    pc.putc(STARTMSG);
    pc.putc(msg->destAddr);
    pc.putc(msg->srcAddr);
    pc.putc(msg->ctrl);
    pc.putc(msg->size);
    pc.putc(msg->command);
    pc.putc(msg->arg);
    pc.putc(msg->crc);
    flushSerialBuffer(pc);
}
void forward_msg(message_t *msg)
{
    forward.putc(STARTMSG);
    forward.putc(msg->destAddr);
    forward.putc(msg->srcAddr);
    forward.putc(msg->ctrl);
    forward.putc(msg->size);
    forward.putc(msg->command);
    forward.putc(msg->arg);
    forward.putc(msg->size);
    forward.putc(msg->crc);
   // pc.putc(0x55);
    flushSerialBuffer(forward);
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
                // pc.printf("ALL Node\n");
                powerQueue.put(msg);
                brakeQueue.put(msg);
                statusQueue.put(msg);
                alarmQueue.put(msg);
                forward_msg(msg);
            } else if(msg->destAddr == 0x00) {
                reply_msg(msg);
            } else {
                bool inlist = false;
                for(int i=0; i<NUMDEVICES; i++) {
                    if(devices[i].id == msg->destAddr) {
                        devices[i].q->put(msg);
                        inlist = true;
                    }
                }
                if(!inlist) {
                    forward_msg(msg);
                }
            }
        }
    }

}
void init()
{
    srand(1);
    devices[0].id = 0x21;//(rand()%16)+1;
    devices[0].status = 0;
    devices[0].function = 0x0001;
    devices[0].q = &powerQueue;

    devices[1].id = 0x22;//(rand()%16)+1;
    devices[1].status = 0;
    devices[1].function = 0x0002;
    devices[1].q = &brakeQueue;

    devices[2].id = 0x23;//(rand()%16)+1;
    devices[2].status = 0;
    devices[2].function = 0x0003;
    devices[2].q = &statusQueue;

    devices[3].id = 0x24;//(rand()%16)+1;
    devices[3].status = 0;
    devices[3].function = 0x0004;
    devices[3].q = &alarmQueue;
}
void pc_listen()
{
    static int index = 0;
    char ch = pc.getc();
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

            break;
        case 1:
            //Destination
            if(ch == 0x00) {

                msg.destAddr = ch;
                index++;
            } else {
                index=0;
            }
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
void controlFcn()
{
    Nunchuk::NunchukData data;
    while(1) {
        nc->GetData(data);
        position = data.yStick;
        //pc.putc(position);
        wait(0.1);
    }
}
// main() runs in its own thread in the OS
int main()
{
    nc = new  Nunchuk(i2c);
    init();
    nc->Init();
    powerDevice.start(powerFcn);
    brakeDevice.start(brakeFcn);
    statusDevice.start(statusFcn);
    alarmDevice.start(alarmFcn);

    nodeDevice.start(nodeFcn);
    controlDevice.start(controlFcn);

    pc.attach(pc_listen, Serial::RxIrq);
    forward.attach(forward_listen, Serial::RxIrq);


    while (true) {
        led1 = !led1;
        wait(0.5);
    }
}

