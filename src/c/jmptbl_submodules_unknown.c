/* RESTORES: UNKNOWN_JMPTBL_ESQIFF2_ReadSerialRecordIntoBuffer,
 *           UNKNOWN_JMPTBL_DISPLIB_DisplayTextAtPosition,
 *           UNKNOWN_JMPTBL_ESQ_WildcardMatch,
 *           UNKNOWN_JMPTBL_DST_NormalizeDayOfYear,
 *           UNKNOWN_JMPTBL_ESQ_GenerateXorChecksumByte,
 *           ESQPROTO_JMPTBL_ESQPARS_ReplaceOwnedString
 * MODULE:   modules/submodules/unknown.s   (6 of its 12 labels)
 * STATUS:   behavioural
 *
 * The six jump-table thunks at the tail of the RBF protocol module. Each is one
 * `JMP target` in the original, so the module is a jump table with six real
 * functions in front of it rather than a table of its own -- which is why
 * tools/jmptbl_to_c.py cannot generate this file and it is written by hand.
 *
 * EVERY SIGNATURE IS COPIED FROM THE TARGET'S OWN RESTORATION, not from the
 * thunk. A thunk written `void f(void)` compiles, links, and silently passes no
 * arguments; AGENTS.md records that as a whole bug class in this project. The
 * six targets and where their declarations come from:
 *
 *   ESQIFF2_ReadSerialRecordIntoBuffer  esqproto_parse.c
 *   DISPLIB_DisplayTextAtPosition       esqproto_parse.c
 *   ESQ_WildcardMatch                   wdisp_draw_weather_status_overlay.c
 *   DST_NormalizeDayOfYear              dst_normalize_day_of_year.c
 *   ESQ_GenerateXorChecksumByte         esqproto_parse.c
 *   ESQPARS_ReplaceOwnedString          esqproto_parse.c
 *
 * SASC-MISMATCH: tail-jump
 *   ref:     JMP target                 (6 bytes under ESQ_FARCALLS=1)
 *   got:     BSR/JSR target then RTS    (+2 bytes and one extra frame)
 *   summary: the original leaves the caller's return address for the target to
 *            return through. SAS/C emits a call and a return. Same arguments,
 *            same result, one more frame for the duration of the call. This is
 *            the same divergence every converted jump table carries.
 *   scope:   all 26 converted tables.
 *   retest:  needs a compiler that can emit a tail jump, which SAS/C 6.51
 *            cannot.
 */
#include <graphics/rastport.h>

extern short ESQIFF2_ReadSerialRecordIntoBuffer(char *buf, long mode, long extra);
extern void  DISPLIB_DisplayTextAtPosition(struct RastPort *rp, long x, long y,
                                           char *text);
extern char  ESQ_WildcardMatch(char *pattern, char *text);
extern short DST_NormalizeDayOfYear(short day, short year);
extern long  ESQ_GenerateXorChecksumByte(long seed, char *buf, long len);
extern char *ESQPARS_ReplaceOwnedString(char *src, char *owned);

short UNKNOWN_JMPTBL_ESQIFF2_ReadSerialRecordIntoBuffer(char *buf, long mode,
                                                        long extra)
{
    return ESQIFF2_ReadSerialRecordIntoBuffer(buf, mode, extra);
}

void UNKNOWN_JMPTBL_DISPLIB_DisplayTextAtPosition(struct RastPort *rp, long x,
                                                  long y, char *text)
{
    DISPLIB_DisplayTextAtPosition(rp, x, y, text);
}

char UNKNOWN_JMPTBL_ESQ_WildcardMatch(char *pattern, char *text)
{
    return ESQ_WildcardMatch(pattern, text);
}

short UNKNOWN_JMPTBL_DST_NormalizeDayOfYear(short day, short year)
{
    return DST_NormalizeDayOfYear(day, year);
}

long UNKNOWN_JMPTBL_ESQ_GenerateXorChecksumByte(long seed, char *buf, long len)
{
    return ESQ_GenerateXorChecksumByte(seed, buf, len);
}

char *ESQPROTO_JMPTBL_ESQPARS_ReplaceOwnedString(char *src, char *owned)
{
    return ESQPARS_ReplaceOwnedString(src, owned);
}
