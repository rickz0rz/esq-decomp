/* RESTORES: _TLIBA2_ComputeBroadcastTimeWindow
 * MODULE:   modules/groups/b/a/tliba2_p2.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: a5-frame
 *   ref:     4e55ffdc48e737323e2d000a266d000c2c2d00102a2d0014246d001841f90000a31243f90000cda42c4970042cd851c8fffc3c9030390000cdac720cb041660834390000cdb6670e7405b0426c7430390000cdb6666c2005742790824a806a025280e2803b40ffe07026ba806f2a20057601c0835380660870003b40ffde6006701e3b40ffde200590824a806a025280e2803b40ffe0605420057601c0835380660870003b40ffde60063b7cffe2ffde94854a826a025282e28244823b42ffe0602a20057401c0825380660870003b40ffde6006701e3b40ffde240553824a826a025282e2825a823b42ffe0200748c074001439000087bab08267067018d16dffe041edffe2700420d951c8fffc30913b41ffea70003b40ffec3b40fff4302dffe048c0322dffde48c12f012f00486dffe24eba009c4fef000c302dffe848c02480302dffe448c025400004302dffe648c025400008302dffea48c0206d001c2080322dffec48c121410004700cb090660c322dfff466067400208260122210b2806c0c342dfff452426604700cd190200b6716486dfff82f062f0b6100fd744fef000c3b40ffdc600670003b40ffdc4a406712202dfffc206d001cb0a800046f04214000044cdf4cec4e5d4e750000
 *   got:     9efc002448e737342a2f00542c2f00503e2f004a246f005c266f00582a6f004c41f90000000043f900000000700422d851c8fffc32d8303900000000720cb0416608343900000000670e7405b0426c7030390000000066682005742790824a806a025280e2803f4000247026ba806f2820057601c08353806606426f00226006701e3f400022200590824a806a025280e2803f400024605020057601c08353806606426f002260063f7cffe2002294854a826a025282e28244823f420024602820057401c08253806606426f00226006701e3f400022200553804a806a025280e2805a803f400024300748c07400143900000000b08267067018d16f002441f90000000043ef0026700422d851c8fffc32d83f41002e426f0030426f0038302f002448c0322f002248c12f012f00486f002e610000004fef000c302f002c48c02680302f002848c027400004302f002a48c027400008302f002e48c02480322f003048c125410004700cb092660c322f003866067400248260122212b2806c0c342f003852426604700cd192200d6716486f003c2f062f0d610000004fef000c3f400020600670003f4000204a40670e202f0040b0aa00046f04254000044cdf2cecdefc00244e75
 *   summary: 456 got vs 464 ref, eight bytes short. The month field is set to a literal 12 and that is not a guess: MOVEQ #12,D1 at 0x2EC1C sits on the unconditional entry path, nothing writes D1 again before MOVE.W D1,-22(A5) at 0x2ECF2, and the disassembly of every intervening branch confirms it -- the original compiler kept the constant from the SnapshotB comparison in a register for 214 bytes. 6.51 rematerialises it. The rest is the frame register. The three-way December and month-under-5 gate, both slot parities selecting 0 or plus-or-minus 30 days, the three minute offsets, the 24-minute group correction, the 22-byte clock copy, the 12-hour wrap on the returned pair and the parsed-window widening all match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
struct BroadcastClock {
    short f0;
    short f2;
    short f4;
    short f6;
    short month;                /* +8 */
    short f10;
    short f12;
    short f14;
    short f16;
    short f18;
    short f20;
};                              /* 22 bytes */

struct BroadcastWindow {
    long a;
    long b;
    long c;
};

struct BroadcastPair {
    long a;
    long b;
};

extern struct BroadcastClock CLOCK_CurrentDayOfWeekIndex;
extern struct BroadcastClock TLIBA2_BroadcastWindowClockSnapshotA;
extern short TLIBA2_BroadcastWindowClockSnapshotB;
extern short TLIBA2_BroadcastWindowClockSnapshotC;
extern unsigned char TEXTDISP_PrimaryGroupCode;

extern long TLIBA2_JMPTBL_DST_AddTimeOffset(struct BroadcastClock *clock,
                long minutes, long days);
extern short TLIBA2_ParseEntryTimeWindow(char *entry, long mode,
                struct BroadcastPair *out);

void TLIBA2_ComputeBroadcastTimeWindow(short group, char *entry, long mode,
                                       long slot, struct BroadcastWindow *out,
                                       struct BroadcastPair *span)
{
    struct BroadcastClock local;
    struct BroadcastPair  parsed;
    short offsetMinutes;
    short offsetDays;
    short parsedOk;

    TLIBA2_BroadcastWindowClockSnapshotA = CLOCK_CurrentDayOfWeekIndex;

    if ((TLIBA2_BroadcastWindowClockSnapshotB == 12
         && TLIBA2_BroadcastWindowClockSnapshotC == 0)
        || (TLIBA2_BroadcastWindowClockSnapshotB < 5
            && TLIBA2_BroadcastWindowClockSnapshotC == 0)) {

        offsetMinutes = (slot - 39) / 2;
        if (slot > 38) {
            if ((slot & 1) == 1)
                offsetDays = 0;
            else
                offsetDays = 30;
            offsetMinutes = (slot - 39) / 2;
        } else {
            if ((slot & 1) == 1)
                offsetDays = 0;
            else
                offsetDays = -30;
            offsetMinutes = -((39 - slot) / 2);
        }
    } else {
        if ((slot & 1) == 1)
            offsetDays = 0;
        else
            offsetDays = 30;
        offsetMinutes = (slot - 1) / 2 + 5;
    }

    if ((long)group != (long)TEXTDISP_PrimaryGroupCode)
        offsetMinutes = offsetMinutes + 24;

    local = TLIBA2_BroadcastWindowClockSnapshotA;
    local.month = 12;
    local.f10 = 0;
    local.f18 = 0;

    TLIBA2_JMPTBL_DST_AddTimeOffset(&local, (long)offsetMinutes,
                                    (long)offsetDays);

    out->a = local.f6;
    out->b = local.f2;
    out->c = local.f4;

    span->a = local.month;
    span->b = local.f10;

    if (span->a == 12 && local.f18 == 0) {
        span->a = 0;
    } else if (span->a < 12 && local.f18 + 1 == 0) {
        span->a = span->a + 12;
    }

    if (entry != 0)
        parsedOk = TLIBA2_ParseEntryTimeWindow(entry, mode, &parsed);
    else
        parsedOk = 0;

    if (parsedOk == 0)
        return;

    if (parsed.b > span->b)
        span->b = parsed.b;
}
