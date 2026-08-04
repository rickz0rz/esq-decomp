/* RESTORES: DATETIME_FormatPairToStream
 * MODULE:   modules/groups/a/j/dst2.s
 * STATUS:   behavioural
 *
 * 452 bytes in the original, 420 emitted, 30 differing regions. Smaller again,
 * for the usual reason: the original spills the current record pointer to -4(A5)
 * on every use and SAS/C keeps it in a register.
 *
 * Reproduces: the three-way structure (no pair at all / no in-time / no out-time
 * each appending their own message), the symmetric in-time and out-time blocks
 * with their distinct format strings and prefix codes 4 and 19, the
 * SPrintf-into-scratch-then-AppendAtNull pairing throughout, the record field
 * layout (dateCode at 6, hour at 8, minute at 10, subCode at 16, pmFlag at 18),
 * and the inlined-strlen length passed to DISKIO_WriteBufferedBytes.
 *
 * The 12-hour conversion is worth noting as a second instance of the
 * divide-helper-result-sharing class first recorded in
 * textdisp_format_entry_time.c. The original computes
 *
 *     hour = (h % 12) + (pmFlag ? 12 : 0)
 *
 * with a single MATH_DivS32 call, taking the REMAINDER from D1 and discarding
 * the quotient in D0 -- then reusing D0 as the scratch for the 0/12 selector.
 * Written as % in C, SAS/C emits its own helper and cannot share the register
 * that way.
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   ref:     4e55ff74                   LINK.W A5,#-140
 *   got:     9efc008c                   SUBA.W #140,A7
 *   summary: The A5-frame class. Both scratch buffers and the record pointer move
 *            from -n(A5) to n(A7).
 *
 * SASC-MISMATCH: divide-helper-result-sharing
 *   summary: see the note above.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for all fourteen cross-unit calls.
 */
#include <string.h>

struct DstRec {
    short pad0, pad1, pad2;
    short dateCode;      /*  6 */
    short hour;          /*  8 */
    short minute;        /* 10 */
    short pad6, pad7;
    short subCode;       /* 16 */
    short pmFlag;        /* 18 */
};

struct DstPair {
    struct DstRec *in;
    struct DstRec *out;
};

extern void WDISP_SPrintf();
extern void STRING_AppendAtNull(char *dst, char *src);
extern void DISKIO_WriteBufferedBytes(long stream, char *buf, long len);
extern char DST_FMT_PCT_C_InTimePrefixChar[];
extern char DST_FMT_PCT_04D_PCT_03D_InTimeDateCode[];
extern char DST_FMT_PCT_02D_COLON_PCT_02D_InTimeClock[];
extern char DST_FMT_PCT_C_OutTimePrefixChar[];
extern char DST_FMT_PCT_04D_PCT_03D_OutTimeDateCode[];
extern char DST_FMT_PCT_02D_COLON_PCT_02D_OutTimeClock[];
extern char DST_STR_NO_IN_TIME[];
extern char DST_STR_NO_OUT_TIME[];
extern char DST_STR_NO_DST_DATA[];

void DATETIME_FormatPairToStream(long stream, struct DstPair *pair)
{
    char tmp[51];
    char out[87];
    struct DstRec *rec;
    register long hour;

    out[0] = 0;

    if (pair == 0) {
        STRING_AppendAtNull(out, DST_STR_NO_DST_DATA);
    } else {
        rec = pair->in;
        if (rec == 0) {
            STRING_AppendAtNull(out, DST_STR_NO_IN_TIME);
        } else {
            WDISP_SPrintf(tmp, DST_FMT_PCT_C_InTimePrefixChar, 4L);
            STRING_AppendAtNull(out, tmp);
            WDISP_SPrintf(tmp, DST_FMT_PCT_04D_PCT_03D_InTimeDateCode,
                                          (long)rec->dateCode, (long)rec->subCode);
            STRING_AppendAtNull(out, tmp);
            hour = rec->hour % 12 + (rec->pmFlag ? 12 : 0);
            WDISP_SPrintf(tmp, DST_FMT_PCT_02D_COLON_PCT_02D_InTimeClock,
                                          hour, (long)rec->minute);
            STRING_AppendAtNull(out, tmp);
        }

        rec = pair->out;
        if (rec == 0) {
            STRING_AppendAtNull(out, DST_STR_NO_OUT_TIME);
        } else {
            WDISP_SPrintf(tmp, DST_FMT_PCT_C_OutTimePrefixChar, 19L);
            STRING_AppendAtNull(out, tmp);
            WDISP_SPrintf(tmp, DST_FMT_PCT_04D_PCT_03D_OutTimeDateCode,
                                          (long)rec->dateCode, (long)rec->subCode);
            STRING_AppendAtNull(out, tmp);
            hour = rec->hour % 12 + (rec->pmFlag ? 12 : 0);
            WDISP_SPrintf(tmp, DST_FMT_PCT_02D_COLON_PCT_02D_OutTimeClock,
                                          hour, (long)rec->minute);
            STRING_AppendAtNull(out, tmp);
        }
    }

    DISKIO_WriteBufferedBytes(stream, out, (long)strlen(out));
}
