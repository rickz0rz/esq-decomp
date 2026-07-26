/* RESTORES: DISKIO_GetFilesizeFromHandle
 * MODULE:   modules/groups/a/g/diskio.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: a6-preserved-across-libcall
 *   ref:     48e733002e2f00142207740076012c790000d9304eaeffbe220726024eaeffbe2c00220776ff4eaeffbe20064cdf00cc4e75
 *   got:     48e733022e2f001822072c7900000000740076014eaeffbe220726024eaeffbe2c00220776ff4eaeffbe20064cdf40cc4e75
 *   summary: Same length and the same three Seek() calls. The ONLY difference is
 *            that SAS/C 6.51 adds A6 to the MOVEM save/restore masks (48E73302 /
 *            4CDF40CC vs 48E73300 / 4CDF00CC), which pushes the parameter's stack
 *            offset from 20 to 24 and reorders the DOSBase load ahead of the D2/D3
 *            setup. The original treats A6 as scratch across a library call.
 *   scope:   Every OS-calling function in the program; the largest single class.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C.
 *
 * NOTE: reaches DOSBase through <proto/dos.h>, so the emitted symbol is _DOSBase
 * while the assembly calls the same pointer Global_REF_DOS_LIBRARY_2. That only
 * matters for linking, and this file is behavioural so it is not linked.
 */
#include <proto/dos.h>
long DISKIO_GetFilesizeFromHandle(BPTR fh)
{
    register long size;
    Seek(fh, 0, OFFSET_END);
    size = Seek(fh, 0, OFFSET_CURRENT);
    Seek(fh, 0, OFFSET_BEGINNING);
    return size;
}
