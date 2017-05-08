#ifndef NUNCHUK_H
#define NUNCHUK_H

#include "mbed.h"

/** Class to interface with a wii Nunchuk.
 */
class Nunchuk
{
public:
    /** Struct to hold the nunchuk data.
     */
    typedef struct
    {
        int xStick;
        int yStick;
        int xAcc;
        int yAcc;
        int zAcc;
        bool bButtonC;
        bool bButtonZ;
    } NunchukData;
    
    /** Construct a Nunchuk object.
     *
     * @param i2c I2C channel to use.
     */
    Nunchuk(I2C& i2c);
  
    /** Send initialization command to nunchuk.
     *
     * @returns true when successful
     */
    bool Init();
    
    /** Get nunchuk data.
     *
     * @param data struct to be filled
     * @returns true when successful
     */
    bool GetData(NunchukData& data);
    
    /** Get nunchuk identification.
     *
     * @param data array of 6 chars be filled with the identification.
     * @returns true when successful
     */
    bool GetIdent(char* pData);
    
private:
    I2C&        _i2c;
    const int   ADDRESS;
};

#endif
