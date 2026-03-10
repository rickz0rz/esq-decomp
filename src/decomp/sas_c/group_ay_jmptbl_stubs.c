typedef signed long LONG;

extern char *DISKIO_ConsumeCStringFromWorkBuffer(void);
extern long DISKIO_ParseLongFromWorkBuffer(void);
extern void DISKIO_WriteDecimalField(void);
extern void DISKIO_WriteBufferedBytes(void);
extern void DISKIO_CloseBufferedFileAndFlush(void);
extern long STRING_CompareNoCaseN(void);
extern long MATH_Mulu32(void);
extern long DISKIO_LoadFileToWorkBuffer(void);
extern LONG SCRIPT_ReadHandshakeBit5Mask(void);
extern void DISKIO_OpenFileWithBuffer(void);

char *GROUP_AY_JMPTBL_DISKIO_ConsumeCStringFromWorkBuffer(void)
{
    return DISKIO_ConsumeCStringFromWorkBuffer();
}

long GROUP_AY_JMPTBL_DISKIO_ParseLongFromWorkBuffer(void)
{
    return DISKIO_ParseLongFromWorkBuffer();
}

void GROUP_AY_JMPTBL_DISKIO_WriteDecimalField(void)
{
    DISKIO_WriteDecimalField();
}

void GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes(void)
{
    DISKIO_WriteBufferedBytes();
}

void GROUP_AY_JMPTBL_DISKIO_CloseBufferedFileAndFlush(void)
{
    DISKIO_CloseBufferedFileAndFlush();
}

long GROUP_AY_JMPTBL_STRING_CompareNoCaseN(void)
{
    return STRING_CompareNoCaseN();
}

long GROUP_AY_JMPTBL_MATH_Mulu32(void)
{
    return MATH_Mulu32();
}

long GROUP_AY_JMPTBL_DISKIO_LoadFileToWorkBuffer(void)
{
    return DISKIO_LoadFileToWorkBuffer();
}

LONG GROUP_AY_JMPTBL_SCRIPT_ReadCiaBBit5Mask(void)
{
    return SCRIPT_ReadHandshakeBit5Mask();
}

void GROUP_AY_JMPTBL_DISKIO_OpenFileWithBuffer(void)
{
    DISKIO_OpenFileWithBuffer();
}
