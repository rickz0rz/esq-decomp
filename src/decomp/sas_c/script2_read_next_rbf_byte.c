extern long SCRIPT2_JMPTBL_ESQ_ReadSerialRbfByte(void);

long SCRIPT_ReadNextRbfByte(void)
{
    return SCRIPT2_JMPTBL_ESQ_ReadSerialRbfByte();
}
