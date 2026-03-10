typedef signed long LONG;

extern char *DISKIO_ConsumeCStringFromWorkBuffer(void);
extern long DISKIO_ParseLongFromWorkBuffer(void);
extern void DISKIO_WriteDecimalField(LONG handle, LONG value);
extern LONG DISKIO_WriteBufferedBytes(LONG handle, const void *src, LONG len);
extern LONG DISKIO_CloseBufferedFileAndFlush(LONG fileHandle);
extern long STRING_CompareNoCaseN(const char *a, const char *b, LONG maxLen);
extern long MATH_Mulu32(LONG a, LONG b);
extern long DISKIO_LoadFileToWorkBuffer(const char *path);
extern LONG SCRIPT_ReadHandshakeBit5Mask(void);
extern LONG DISKIO_OpenFileWithBuffer(const char *filePath, LONG accessMode);

char *GROUP_AY_JMPTBL_DISKIO_ConsumeCStringFromWorkBuffer(void)
{
    return DISKIO_ConsumeCStringFromWorkBuffer();
}

long GROUP_AY_JMPTBL_DISKIO_ParseLongFromWorkBuffer(void)
{
    return DISKIO_ParseLongFromWorkBuffer();
}

void GROUP_AY_JMPTBL_DISKIO_WriteDecimalField(LONG handle, LONG value)
{
    DISKIO_WriteDecimalField(handle, value);
}

LONG GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes(LONG handle, const void *src, LONG len)
{
    return DISKIO_WriteBufferedBytes(handle, src, len);
}

LONG GROUP_AY_JMPTBL_DISKIO_CloseBufferedFileAndFlush(LONG fileHandle)
{
    return DISKIO_CloseBufferedFileAndFlush(fileHandle);
}

long GROUP_AY_JMPTBL_STRING_CompareNoCaseN(const char *a, const char *b, LONG maxLen)
{
    return STRING_CompareNoCaseN(a, b, maxLen);
}

long GROUP_AY_JMPTBL_MATH_Mulu32(LONG a, LONG b)
{
    return MATH_Mulu32(a, b);
}

long GROUP_AY_JMPTBL_DISKIO_LoadFileToWorkBuffer(const char *path)
{
    return DISKIO_LoadFileToWorkBuffer(path);
}

LONG GROUP_AY_JMPTBL_SCRIPT_ReadCiaBBit5Mask(void)
{
    return SCRIPT_ReadHandshakeBit5Mask();
}

LONG GROUP_AY_JMPTBL_DISKIO_OpenFileWithBuffer(const char *filePath, LONG accessMode)
{
    return DISKIO_OpenFileWithBuffer(filePath, accessMode);
}
