typedef signed long LONG;

/*
 * Exported return-tail symbol from the original assembly. This C stub is used
 * to keep the SAS/C lane wired while this tail remains split from its parent
 * function in the assembly source.
 */
LONG ESQFUNC_TrimTextToPixelWidthWordBoundary_Return(LONG value)
{
    return value;
}
