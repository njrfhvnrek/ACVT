#include <8052.h>
#include <htc.h>

int flag;

void imp(unsigned int cnt)
{
    do{ 
        if (cnt != 0) {cnt--; P10 = 1;}
        else P10 = 0;

    } while (TF2 == 0);
    TF2 = 0; 
    if (P00 == 1) {flag = 1;}
    if (P01 == 1) {flag = 0;}
}

void main()
{
    flag = 0;
    P1 = 0xFE;
    
    RCAP2H = 0x05;
    RCAP2L = 0x59;
 
    T2CON &= 0xFC;
    ET2 = 1;
    EA = 1;
    T2CON |= 0x4;

    while(1)
    {
        if (flag == 1)
        {
            imp(2583);
        }
        else
        {
            imp(1845);
        }
        
        if (P00 == 1) {flag = 1;}
        if (P01 == 1) {flag = 0;}
    }
}