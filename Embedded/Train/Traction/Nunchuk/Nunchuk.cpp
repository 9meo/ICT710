#include "Nunchuk.h"

Nunchuk::Nunchuk(I2C& i2c)
: _i2c(i2c)
, ADDRESS(0xA4)
{
    _i2c.frequency(400000);
}

//*** Public functions ***

bool Nunchuk::Init()
{
    char cmd[2];
    bool bResult;

    // Disable encryption.
    cmd[0] = 0xF0;
    cmd[1] = 0x55;
    bResult = _i2c.write(ADDRESS, cmd, 2) == 0;

    if (bResult)
    {
        cmd[0] = 0xFB;
        cmd[1] = 0x00;
        bResult = _i2c.write(ADDRESS, cmd, 2) == 0;
    }

    return bResult;
}
    
bool Nunchuk::GetIdent(char* pData)
{
    char cmd[1];
    bool bResult = false;
       
    // Read the 6 bytes of identification.
    cmd[0] = 0xFA;
    if (_i2c.write(ADDRESS, cmd, 1) == 0)
    {
        bResult = _i2c.read(ADDRESS, pData, 6) == 0;
    }

    return bResult;
}
    
bool Nunchuk::GetData(NunchukData& data)
{
    char cmd[1];
    char buffer[6];
    bool bResult = false;
    
    // Request data.
    cmd[0] = 0x00;
    if (_i2c.write(ADDRESS, cmd, 1) == 0)
    {
        // Read the 6 bytes of data.
        if (_i2c.read(ADDRESS, buffer, 6) == 0)
        {
            data.xStick   = buffer[0];
            data.yStick   = buffer[1];
            data.xAcc     = (buffer[2] << 2) + ((buffer[5] & 0x0C) >> 2);
            data.yAcc     = (buffer[3] << 2) + ((buffer[5] & 0x30) >> 4);
            data.zAcc     = (buffer[4] << 2) + ((buffer[5] & 0xC0) >> 6);
            data.bButtonZ = (buffer[5] & 1) == 0;
            data.bButtonC = (buffer[5] & 2) == 0;
            
            bResult = true;
        }
    }
    return bResult;
}

//*** Private functions ***
    
