typedef signed long LONG;
typedef unsigned char UBYTE;

extern UBYTE CIAB_PRA;

LONG SCRIPT_ReadHandshakeBit3Flag(void)
{
    return ((CIAB_PRA & (UBYTE)(1u << 3)) != 0) ? 1 : 0;
}
