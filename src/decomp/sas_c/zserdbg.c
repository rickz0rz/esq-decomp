/* Interrupt-safe raw-serial debug. Writes to SERDAT ($DFF030) with a bounded TBE
   poll; also usable from sequential code to validate the serial->TCP path. */
void SERPUT(long c)
{
    volatile unsigned short *serdatr = (volatile unsigned short *)0x00DFF018UL;
    volatile unsigned short *serdat  = (volatile unsigned short *)0x00DFF030UL;
    long guard = 300000;
    while (((*serdatr & 0x2000) == 0) && (guard-- > 0)) { }
    *serdat = (unsigned short)(0x100 | (c & 0xFF));
    guard = 4000; while (guard-- > 0) { }   /* brief settle so back-to-back bytes don't drop */
}
