extern void DISKIO_ConsumeCStringFromWorkBuffer(void);
extern void DISKIO_ParseLongFromWorkBuffer(void);
extern void DISKIO_WriteDecimalField(void);
extern void DISKIO_WriteBufferedBytes(void);
extern void DISKIO_CloseBufferedFileAndFlush(void);
extern void STRING_CompareNoCaseN(void);
extern void MATH_Mulu32(void);
extern void DISKIO_LoadFileToWorkBuffer(void);
extern void SCRIPT_ReadHandshakeBit5Mask(void);
extern void DISKIO_OpenFileWithBuffer(void);

void GROUP_AY_JMPTBL_DISKIO_ConsumeCStringFromWorkBuffer(void)
{
    DISKIO_ConsumeCStringFromWorkBuffer();
}

void GROUP_AY_JMPTBL_DISKIO_ParseLongFromWorkBuffer(void)
{
    DISKIO_ParseLongFromWorkBuffer();
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

void GROUP_AY_JMPTBL_STRING_CompareNoCaseN(void)
{
    STRING_CompareNoCaseN();
}

void GROUP_AY_JMPTBL_MATH_Mulu32(void)
{
    MATH_Mulu32();
}

void GROUP_AY_JMPTBL_DISKIO_LoadFileToWorkBuffer(void)
{
    DISKIO_LoadFileToWorkBuffer();
}

void GROUP_AY_JMPTBL_SCRIPT_ReadCiaBBit5Mask(void)
{
    SCRIPT_ReadHandshakeBit5Mask();
}

void GROUP_AY_JMPTBL_DISKIO_OpenFileWithBuffer(void)
{
    DISKIO_OpenFileWithBuffer();
}
