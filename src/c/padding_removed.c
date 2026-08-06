/* RESTORES: (nothing -- see strings_now_local_main_a.c for the pattern)
 * MODULE:   thirteen alignment-padding modules; see replacements-extra.txt
 * STATUS:   behavioural
 *
 * DELIBERATELY EMPTY, and shared by every pure-padding module.
 *
 * Each of those modules contains nothing but filler: an `ALIGN_WORD`, which
 * src/macros.s defines as `DC.W $0000`, or a couple of bytes the disassembler
 * rendered as instructions because that is what a disassembler does with
 * padding -- `ORI.B #0,D0` is `0000 0000` and `MOVEQ #97,D0` is `7061`, which
 * is the ASCII "pa" left over from a preceding string.
 *
 * THE PADDING ALIGNS THE ORIGINAL'S LAYOUT, AND THE MAXIMUM-C IMAGE DOES NOT
 * HAVE THAT LAYOUT. It is 235,484 CODE bytes against the reference's 211,348,
 * every function is a different size, and gen_units.py coalesces modules to
 * 4-byte boundaries on its own. So the filler aligns nothing here.
 *
 * IT CANNOT BE WRITTEN IN C, WHICH IS WHY IT IS REMOVED RATHER THAN CONVERTED.
 * SAS/C puts every string literal and initialised static in `data` -- measured:
 * `char p[2] = {0,0}`, `char p[2] = "\0"` and the const form all emit
 * HUNK_DATA and HUNK_CODE of zero. Bytes only reach the code section as
 * instruction operands inside a function, and there is no C that emits exactly
 * `DC.W 0`: an empty function is `RTS`, which is 0x4E75.
 *
 * THE ASSEMBLY MODULES STAY ON DISK. src/Prevue.asm is what the byte-exact
 * build assembles, and removing an include would move every byte after it and
 * fail test-hash.sh. Only the maximum-C build drops them.
 *
 * ONE FILE SERVES ALL THIRTEEN ROWS. It defines no symbols, so linking the same
 * empty object more than once cannot collide.
 */
