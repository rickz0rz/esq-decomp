#include <exec/types.h>

typedef struct NEWGRID_Context {
    UBYTE pad0[54];
    UBYTE selectionCode;
} NEWGRID_Context;

extern UBYTE CONFIG_NewgridSelectionCode16EnabledFlag;
extern UBYTE CONFIG_NewgridSelectionCode32EnabledFlag;
extern UBYTE CONFIG_NewgridSelectionCode34PrimaryEnabledFlag;
extern UBYTE CONFIG_NewgridSelectionCode34AltEnabledFlag;
extern UBYTE CONFIG_NewgridSelectionCode35EnabledFlag;
extern UBYTE CONFIG_NewgridSelectionCode48_49EnabledFlag;
extern UBYTE GCOMMAND_DigitalNicheEnabledFlag;
extern UBYTE GCOMMAND_DigitalMplexEnabledFlag;
extern UBYTE GCOMMAND_DigitalPpvEnabledFlag;

void NEWGRID_ValidateSelectionCode(char *gridCtx, LONG code)
{
    NEWGRID_Context *ctx;
    ULONG currentCode;

    ctx = (NEWGRID_Context *)gridCtx;
    currentCode = (ULONG)ctx->selectionCode;
    if (currentCode >= (ULONG)code) {
        if (code == 0) {
            ctx->selectionCode = (UBYTE)code;
        }
        return;
    }

    if (code == 16) {
        if (CONFIG_NewgridSelectionCode16EnabledFlag == (UBYTE)89) {
            ctx->selectionCode = (UBYTE)code;
        }
        return;
    }

    if (code == 32) {
        if (CONFIG_NewgridSelectionCode32EnabledFlag == (UBYTE)89) {
            ctx->selectionCode = (UBYTE)code;
        }
        return;
    }

    if (code == 33) {
        if (GCOMMAND_DigitalNicheEnabledFlag == (UBYTE)89) {
            ctx->selectionCode = (UBYTE)code;
        }
        return;
    }

    if (code == 34 || code == 50) {
        if (CONFIG_NewgridSelectionCode34PrimaryEnabledFlag == (UBYTE)89 ||
            CONFIG_NewgridSelectionCode34AltEnabledFlag == (UBYTE)89) {
            ctx->selectionCode = (UBYTE)code;
        }
        return;
    }

    if (code == 35 || code == 51) {
        if (CONFIG_NewgridSelectionCode35EnabledFlag == (UBYTE)89) {
            ctx->selectionCode = (UBYTE)code;
        }
        return;
    }

    if (code == 36 || code == 52) {
        if (GCOMMAND_DigitalMplexEnabledFlag == (UBYTE)89) {
            ctx->selectionCode = (UBYTE)code;
        }
        return;
    }

    if (code == 37 || code == 53) {
        if (GCOMMAND_DigitalPpvEnabledFlag == (UBYTE)89) {
            ctx->selectionCode = (UBYTE)code;
        }
        return;
    }

    if (code == 48) {
        if (CONFIG_NewgridSelectionCode48_49EnabledFlag == (UBYTE)89) {
            ctx->selectionCode = (UBYTE)code;
        }
        return;
    }

    if (code == 49) {
        if (CONFIG_NewgridSelectionCode48_49EnabledFlag == (UBYTE)89 &&
            GCOMMAND_DigitalNicheEnabledFlag == (UBYTE)89) {
            ctx->selectionCode = (UBYTE)code;
        }
        return;
    }

    if (code >= 64 && code <= 68) {
        ctx->selectionCode = (UBYTE)code;
        return;
    }

    ctx->selectionCode = 0;
}
