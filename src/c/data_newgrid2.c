/* RESTORES: (data module -- no function)
 * MODULE:   data/newgrid2.s
 * STATUS:   behavioural
 *
 * Six copies of the file-name string and six longs, 96 bytes. See
 * src/c/data_displib.c for why a data module can be replaced at all, and
 * AGENTS.md for the two rules that decide whether one may be.
 *
 * 96 IS A MULTIPLE OF 4, so the object gains no padding and the DATA hunk keeps
 * its size. That is the hard limit on the data side: `data/flib.s` is 154 bytes
 * and converting it grew the hunk by 4 and froze the display.
 *
 * "NEWGRID2.c" IS TEN CHARACTERS, SO EACH STRING IS ELEVEN BYTES AND `NStr` PADS
 * IT TO TWELVE. The size is written out because SAS/C 6.51 does not word-align
 * consecutive char arrays; without it the pad byte disappears and every symbol
 * after the first string shifts.
 *
 * The layout is 6 x 12 = 72 for the strings and 6 x 4 = 24 for the longs, and it
 * interleaves: two strings, five longs, four strings, one long. Written in the
 * original's order, the longs land at 24, 28, 32, 36, 40 and 92, all of them
 * 4-aligned without anything having to be arranged.
 *
 * THE FLAG IS INITIALISED TO 1, and it is the only non-zero datum here. The
 * zeros are written out rather than left implicit so SAS/C keeps them in the
 * data section instead of moving them to BSS -- see data_displib.c.
 */

char Global_STR_NEWGRID2_C_1[12] = "NEWGRID2.c";
char Global_STR_NEWGRID2_C_2[12] = "NEWGRID2.c";

long NEWGRID2_CachedModeIndex      = 0;
long NEWGRID2_DispatchStateIndex   = 0;
long NEWGRID2_PendingOperationId   = 0;
long NEWGRID2_LastDispatchResult   = 0;
long NEWGRID2_BufferAllocationFlag = 1;

char Global_STR_NEWGRID2_C_3[12] = "NEWGRID2.c";
char Global_STR_NEWGRID2_C_4[12] = "NEWGRID2.c";
char Global_STR_NEWGRID2_C_5[12] = "NEWGRID2.c";
char Global_STR_NEWGRID2_C_6[12] = "NEWGRID2.c";

long NEWGRID2_ErrorLogEntryPtr = 0;
