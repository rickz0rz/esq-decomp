/* RESTORES: DISKIO_ConsumeLineFromWorkBuffer
 * MODULE:   modules/groups/a/g/diskio_p3.s
 * STATUS:   behavioural
 *
 * Terminates the current line in the shared work buffer and steps the buffer
 * cursor past the line separator. Returns the start of the line, or -1 when
 * the byte budget in Global_REF_LONG_FILE_SCRATCH ran out.
 *
 * The trailing CR/LF skip loop does NOT re-test the byte budget. That is what
 * the original does. It decrements the budget inside the loop, but it never
 * reads the budget again.
 *
 * Sibling of DISKIO_ConsumeCStringFromWorkBuffer and it carries the same
 * divergence class.
 *
 * 140 bytes against 130.
 *
 * SASC-MISMATCH: stack-local-pointer
 *   ref:     4e55fffc 2b7900008004fffc ... 202dfffc 4e5d
 *   got:     48e70104 2a790000000000   ... 200d     4cdf2080
 *   summary: the original holds the returned line start in -4(A5) behind a
 *            LINK A5,#-4. SAS/C 6.51 allocates it to A2 and emits no frame.
 *            Same class as gcommand_find_path_separator.c.
 *   tried:   nothing source-side. The address of the local is never taken.
 *   scope:   program-wide. See gcommand_find_path_separator.c for the list.
 *   retest:  tools/mismatches.py --recheck on a compiler that spills the local.
 *
 * SASC-MISMATCH: word-immediate-pointer
 *   ref:     307cffff       MOVEA.W #-1,A0    (4 bytes, sign-extends to -1)
 *   got:     207cffffffff   MOVEA.L #-1,A0    (6 bytes)
 *   summary: same VALUE, two bytes more to express it. SAS/C has no way to reach
 *            the 4-byte form: MOVEA.W with a negative immediate sign-extends, and
 *            nothing in C asks for that narrowing.
 *
 *   THIS BLOCK USED TO SAY the sentinel could be written 0xFFFF instead, on the
 *   grounds that "every caller tests it only for non-NULL". THAT WAS FALSE and it
 *   cost a working build. Callers test EQUALITY against -1 --
 *   `MOVEA.W #$ffff,A0` / `CMP.L A0,D0` -- so 0x0000FFFF fails the test, the
 *   caller never sees end-of-buffer, and PARSEINI_ParseIniBufferAndDispatch's
 *   read loop never terminates. The machine hangs during startup with the frame
 *   chrome drawn and no text, which no byte gate can see and which probe_esq.sh
 *   reports as a clean boot. Found by soak_esq.sh's freeze check.
 *
 *   DO NOT trade this two-byte difference for a value change again.
 *   tried:   (char *)-1 is correct and is what is here. (char *)0xFFFF matches no
 *            better and is WRONG.
 *   scope:   all three DISKIO work-buffer routines; all were wrong the same way.
 *   retest:  a compiler that narrows a negative pointer constant to MOVEA.W.
 */
extern char *Global_PTR_WORK_BUFFER;
extern long  Global_REF_LONG_FILE_SCRATCH;

char *DISKIO_ConsumeLineFromWorkBuffer(void)
{
    char *start = Global_PTR_WORK_BUFFER;
    long  c;

    while (Global_REF_LONG_FILE_SCRATCH-- > 0) {
        c = *Global_PTR_WORK_BUFFER;
        if (c == 13 || c == 10)
            break;
        Global_PTR_WORK_BUFFER++;
    }
    *Global_PTR_WORK_BUFFER++ = 0;
    if (Global_REF_LONG_FILE_SCRATCH < 0)
        return (char *)-1;
    while ((c = *Global_PTR_WORK_BUFFER) == 13 || c == 10) {
        Global_PTR_WORK_BUFFER++;
        Global_REF_LONG_FILE_SCRATCH--;
    }
    return start;
}
