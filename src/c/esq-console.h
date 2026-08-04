/* console.device RawKeyConvert, reached through ESQ's OWN cached base.
 * Include this, never <proto/console.h>. See esq-libbase.md for the general
 * rule about volatile library bases.
 *
 * This header differs from its siblings in one way, and it is the reason it
 * exists at all: the stock pragma names `ConsoleDevice` as the base, and ESQ
 * does not use that variable. It caches the base in its own global,
 * `_INPUTDEVICE_LibraryBaseFromConsoleIo`, filled in from the console IO
 * request. So the pragma is restated here against that name.
 *
 * The offset and register spec are copied VERBATIM from
 * sc/include/pragmas/console_pragmas.h:
 *
 *     #pragma libcall ConsoleDevice RawKeyConvert 30 A19804
 *
 * `30` is the LVO, which is -0x30 = -48. `04` is the argument count and the
 * nibbles before it give the registers, right to left: 8 = A0, 9 = A1, 1 = D1,
 * A = A2. That is exactly what the original loads:
 *
 *     MOVEM.L 12(A7),A0-A1        ; event, buffer
 *     MOVEM.L 20(A7),D1/A2        ; length, keymap
 *     JSR     _LVOexecPrivate3(A6)
 *
 * which is how `_LVOexecPrivate3` was identified as RawKeyConvert rather than
 * an exec call -- the disassembly's name for the offset is wrong, because the
 * base is the console device, not exec.
 */
#ifndef ESQ_CONSOLE_H
#define ESQ_CONSOLE_H

#include <exec/types.h>
#include <devices/inputevent.h>
#include <devices/keymap.h>

extern struct Library * volatile INPUTDEVICE_LibraryBaseFromConsoleIo;

long INPUTDEVICE_RawKeyConvert(struct InputEvent *event, char *buffer,
                               long length, struct KeyMap *keyMap);
#pragma libcall INPUTDEVICE_LibraryBaseFromConsoleIo INPUTDEVICE_RawKeyConvert 30 A19804

#endif
