typedef signed long LONG;

extern void PARALLEL_WriteCharHw(LONG ch);

void PARALLEL_WriteCharD0(LONG ch)
{
    PARALLEL_WriteCharHw(ch);
}
