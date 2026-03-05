typedef signed long LONG;
typedef unsigned char UBYTE;

extern LONG ESQ_MainInitAndRun(LONG argc, UBYTE **argv);

LONG UNKNOWN29_JMPTBL_ESQ_MainInitAndRun(LONG argc, UBYTE **argv)
{
    return ESQ_MainInitAndRun(argc, argv);
}
