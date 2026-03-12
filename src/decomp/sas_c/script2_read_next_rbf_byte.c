extern long ESQ_ReadSerialRbfByte(void);

long SCRIPT_ReadNextRbfByte(void)
{
    return ESQ_ReadSerialRbfByte();
}
