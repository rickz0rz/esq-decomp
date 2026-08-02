/* RESTORES: _ESQIFF2_ParseLineHeadTailRecord
 * MODULE:   modules/groups/a/o/esqiff2_p1.s
 * STATUS:   behavioural
 *
 * Splits an incoming line record into a HEAD string and a TAIL string, at the
 * 0x12 delimiter, and installs the two into either the primary or the secondary
 * pair depending on the group byte in rec[0].
 *
 * A RECORD FOR NEITHER GROUP IS DROPPED SILENTLY. The group byte is matched
 * against TEXTDISP_PrimaryGroupCode and then TEXTDISP_SecondaryGroupCode, and a
 * record matching neither returns having done nothing -- not even the clear.
 *
 * FOUR SHAPES, and the delimiter position picks between them:
 *   rec[1] == 0x12 and the last byte == 0x12   head and tail both cleared
 *   rec[1] == 0x12 only                        tail only, taken from rec+2
 *   last byte == 0x12 only                     head only, tail cleared
 *   neither                                    scan for an internal delimiter
 *
 * THE INTERNAL SCAN STARTS AT 3 AND STOPS AT 103, and it splits at wherever it
 * STOPPED -- the terminator is written unconditionally, so a record with no
 * delimiter at all is cut at offset 103 rather than rejected. That is a length
 * cap doing double duty as a fallback split.
 *
 * THE TWO HALVES ARE NOT SYMMETRIC, AND THIS IS A DEFECT IN THE ORIGINAL.
 * In the head-only case the PRIMARY path writes the terminator before copying:
 *
 *     MOVEQ #0,D1 / MOVE.W D0,D1 / CLR.B -1(A3,D1.L)   <-- primary
 *     LEA 1(A3),A0                                     <-- secondary, no CLR.B
 *
 * The secondary path has no such store. So a secondary head string keeps the
 * trailing 0x12 delimiter byte that the primary one drops. Every other
 * difference between the two halves is the global it writes; this one changes
 * the DATA. It is reproduced as written, with no attempt to correct it -- see
 * AGENTS.md on preserving original defects rather than fixing them in place.
 *
 * ONLY THE SECONDARY PATH RAISES ESQDISP_SecondaryLinePromotePendingFlag. The
 * promotion of a secondary line to primary is driven from here.
 *
 * ESQIFF_SecondaryLineHeadPtr IS A SPLIT POINTER: the data section stores two
 * bytes at the symbol and the code writes four, taking the following word as the
 * low half. It is one of the eight adjacencies listed in AGENTS.md, and
 * src/c/data_esq.c carries it as two shorts so the layout survives. Declaring it
 * `char *` here reads and writes the same four bytes the assembly does.
 *
 * THE ORIGINAL REUSES A STACK SLOT ACROSS THE TWO CALLS in the split case --
 * `MOVE.L ptr,(A7)` over the first call's argument, then one `LEA 12(A7),A7` to
 * pop both. That is a register-allocation trick with no semantic content, so the
 * C writes two ordinary calls.
 *
 * SASC-MISMATCH: cross-unit-call-encoding
 *   scope:   program-wide under SAS/C 6.51. See AGENTS.md.
 */

extern unsigned char TEXTDISP_PrimaryGroupCode;
extern unsigned char TEXTDISP_SecondaryGroupCode;
extern unsigned short ESQIFF_RecordLength;
extern short ESQDISP_SecondaryLinePromotePendingFlag;
extern char *ESQIFF_PrimaryLineHeadPtr, *ESQIFF_PrimaryLineTailPtr;
extern char *ESQIFF_SecondaryLineHeadPtr, *ESQIFF_SecondaryLineTailPtr;

extern void ESQIFF2_ClearLineHeadTailByMode(long mode);
extern char *ESQPARS_ReplaceOwnedString(char *newText, char *owned);

#define DELIM 18                /* 0x12 */

void ESQIFF2_ParseLineHeadTailRecord(char *rec)
{
    unsigned char group = (unsigned char)rec[0];
    unsigned short len;
    short at;

    if (group == TEXTDISP_PrimaryGroupCode) {
        ESQIFF2_ClearLineHeadTailByMode(1);

        if ((unsigned char)rec[1] == DELIM) {
            ESQIFF_PrimaryLineHeadPtr = 0;
            len = ESQIFF_RecordLength;
            if ((unsigned char)rec[len - 1] == DELIM) {
                ESQIFF_PrimaryLineTailPtr = 0;
                return;
            }
            ESQIFF_PrimaryLineTailPtr =
                ESQPARS_ReplaceOwnedString(rec + 2, ESQIFF_PrimaryLineTailPtr);
            return;
        }

        len = ESQIFF_RecordLength;
        if ((unsigned char)rec[len - 1] == DELIM) {
            rec[len - 1] = 0;               /* the secondary path omits this */
            ESQIFF_PrimaryLineHeadPtr =
                ESQPARS_ReplaceOwnedString(rec + 1, ESQIFF_PrimaryLineHeadPtr);
            ESQIFF_PrimaryLineTailPtr = 0;
            return;
        }

        for (at = 3; (unsigned char)rec[at] != DELIM && at < 103; at++)
            ;
        rec[at] = 0;
        ESQIFF_PrimaryLineHeadPtr =
            ESQPARS_ReplaceOwnedString(rec + 1, ESQIFF_PrimaryLineHeadPtr);
        ESQIFF_PrimaryLineTailPtr =
            ESQPARS_ReplaceOwnedString(rec + (long)at + 1,
                                       ESQIFF_PrimaryLineTailPtr);
        return;
    }

    if (group != TEXTDISP_SecondaryGroupCode)
        return;

    ESQIFF2_ClearLineHeadTailByMode(2);
    ESQDISP_SecondaryLinePromotePendingFlag = 1;

    if ((unsigned char)rec[1] == DELIM) {
        ESQIFF_SecondaryLineHeadPtr = 0;
        len = ESQIFF_RecordLength;
        if ((unsigned char)rec[len - 1] == DELIM) {
            ESQIFF_SecondaryLineTailPtr = 0;
            return;
        }
        ESQIFF_SecondaryLineTailPtr =
            ESQPARS_ReplaceOwnedString(rec + 2, ESQIFF_SecondaryLineTailPtr);
        return;
    }

    len = ESQIFF_RecordLength;
    if ((unsigned char)rec[len - 1] == DELIM) {
        /* NO terminator store here -- the asymmetry described in the header. */
        ESQIFF_SecondaryLineHeadPtr =
            ESQPARS_ReplaceOwnedString(rec + 1, ESQIFF_SecondaryLineHeadPtr);
        ESQIFF_SecondaryLineTailPtr = 0;
        return;
    }

    for (at = 3; (unsigned char)rec[at] != DELIM && at < 103; at++)
        ;
    rec[at] = 0;
    ESQIFF_SecondaryLineHeadPtr =
        ESQPARS_ReplaceOwnedString(rec + 1, ESQIFF_SecondaryLineHeadPtr);
    ESQIFF_SecondaryLineTailPtr =
        ESQPARS_ReplaceOwnedString(rec + (long)at + 1,
                                   ESQIFF_SecondaryLineTailPtr);
}
