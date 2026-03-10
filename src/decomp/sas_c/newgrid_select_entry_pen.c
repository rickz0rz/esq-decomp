typedef signed long LONG;
typedef unsigned char UBYTE;

typedef struct NEWGRID_Entry {
    UBYTE pad0[27];
    UBYTE flags27;
    UBYTE pad1[13];
    UBYTE overridePen41;
    UBYTE overrideLayoutPen42;
} NEWGRID_Entry;

extern LONG NEWGRID_GridOperationId;
extern LONG NEWGRID_OverridePenIndex;

extern LONG GCOMMAND_NicheTextPen;
extern LONG GCOMMAND_NicheFramePen;
extern LONG GCOMMAND_MplexDetailLayoutPen;
extern LONG GCOMMAND_MplexDetailRowPen;
extern LONG GCOMMAND_PpvShowtimesLayoutPen;
extern LONG GCOMMAND_PpvShowtimesRowPen;

LONG NEWGRID_SelectEntryPen(char *entry)
{
    NEWGRID_Entry *entryView;
    LONG pen;
    LONG override;
    LONG op;

    pen = -1;
    entryView = (NEWGRID_Entry *)entry;

    if (entryView != 0) {
        if (entryView->overridePen41 != (UBYTE)0xFF) {
            pen = (LONG)entryView->overridePen41;
        } else if ((entryView->flags27 & 0x02) != 0) {
            pen = 4;
        } else if ((entryView->flags27 & 0x40) != 0) {
            pen = 5;
        } else if ((entryView->flags27 & 0x10) != 0) {
            pen = 7;
        }
    }

    if (pen == -1) {
        op = NEWGRID_GridOperationId - 1;
        switch (op) {
            case 1:
            case 2:
            case 3:
                pen = 6;
                break;
            case 4:
                pen = GCOMMAND_NicheFramePen;
                break;
            case 5:
                pen = GCOMMAND_MplexDetailRowPen;
                break;
            case 6:
                pen = GCOMMAND_PpvShowtimesRowPen;
                break;
            default:
                pen = 7;
                break;
        }
    }

    if (pen < 0 || pen > 15) {
        pen = 7;
    }

    override = -1;
    if (entryView && entryView->overrideLayoutPen42 != (UBYTE)0xFF) {
        override = (LONG)entryView->overrideLayoutPen42;
    }

    if (override == -1) {
        op = NEWGRID_GridOperationId - 1;
        switch (op) {
            case 4:
                override = GCOMMAND_NicheTextPen;
                break;
            case 5:
                override = GCOMMAND_MplexDetailLayoutPen;
                break;
            case 6:
                override = GCOMMAND_PpvShowtimesLayoutPen;
                break;
            default:
                override = 1;
                break;
        }
    }

    if (override < 1 || override > 3) {
        override = 1;
    }

    NEWGRID_OverridePenIndex = override;
    return pen;
}
