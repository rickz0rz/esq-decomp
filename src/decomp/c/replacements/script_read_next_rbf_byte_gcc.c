void SCRIPT2_JMPTBL_ESQ_ReadSerialRbfByte(void) __attribute__((noinline));

void SCRIPT_ReadNextRbfByte(void) __attribute__((noinline, used));

void SCRIPT_ReadNextRbfByte(void)
{
    SCRIPT2_JMPTBL_ESQ_ReadSerialRbfByte();
}
