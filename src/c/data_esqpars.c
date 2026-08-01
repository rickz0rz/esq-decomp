/* RESTORES: (data module -- no function)
 * MODULE:   data/esqpars.s
 * STATUS:   behavioural
 *
 * Nine strings, all `NStr`, no storage and no cross-symbol reads. See
 * src/c/data_displib.c for why a data module can be replaced at all and what
 * `NStr` compiles to.
 *
 * THE SIX IDENTICAL "ESQPARS.c" STRINGS ARE SIX SEPARATE SYMBOLS and must stay
 * that way. A compiler is free to merge equal string LITERALS, but these are
 * initialisers for six named arrays, so each one gets its own storage and its
 * own address. Merging them would shorten the module by 50 bytes and move every
 * symbol after it.
 *
 * EVERY ARRAY CARRIES AN EXPLICIT SIZE. `NStr` ends in `CNOP 0,2` and SAS/C
 * 6.51 does NOT word-align consecutive char arrays, so the padding has to be
 * written into the array size or it is simply lost. The six "ESQPARS.c" strings
 * are 9 characters plus a NUL, which is even and needs none; the three below
 * them are odd and do.
 *
 * WITHOUT THE SIZES THIS MODULE STILL CAME OUT AT 92 BYTES, the right total, with
 * `_ESQPARS_BannerSubcommandSet` at 0x53 instead of 0x54 and
 * `_ESQPARS_DefaultEntryCodeString` at 0x56 instead of 0x58. The two pad bytes it
 * lost and the object rounding it gained cancelled. **Compare the OFFSETS, not
 * the size** -- see data_flib.c, where the same mistake cost 6 bytes and was
 * visible.
 */

char Global_STR_ESQPARS_C_1[10] = "ESQPARS.c";
char Global_STR_ESQPARS_C_2[10] = "ESQPARS.c";
char Global_STR_ESQPARS_C_3[10] = "ESQPARS.c";
char Global_STR_ESQPARS_C_4[10] = "ESQPARS.c";
char Global_STR_ESQPARS_C_5[10] = "ESQPARS.c";
char Global_STR_ESQPARS_C_6[10] = "ESQPARS.c";

char Global_STR_RESET_COMMAND_RECEIVED[24] = "Reset command received";

char ESQPARS_BannerSubcommandSet[4]    = "23";
char ESQPARS_DefaultEntryCodeString[4] = "00";
