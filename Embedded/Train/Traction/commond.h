#define NUMDEVICES 4
#define STARTMSG 0x7E
typedef struct message_t
{
    uint8_t destAddr; 
    uint8_t srcAddr;
    uint8_t ctrl;
    uint8_t size;
    uint8_t command;
    uint8_t arg;
    uint8_t crc;
}message_t;
typedef struct device
{
    uint8_t id;
    int status;
    uint16_t function;
    Queue<message_t, 10> *q;
 }device;
void powerFcn(void);
void brakeFcn(void);
void statusFcn(void);
void alarmFcn(void);
void nodeFcn(void);



// Global variable reference
extern RawSerial pc;
extern RawSerial forward;
extern device devices[4];
extern int position;
extern Queue<message_t, 10> powerQueue;
extern Queue<message_t, 10> brakeQueue;
extern Queue<message_t, 10> alarmQueue;
extern Queue<message_t, 10> statusQueue;
extern Queue<message_t, 10> nodeQueue;