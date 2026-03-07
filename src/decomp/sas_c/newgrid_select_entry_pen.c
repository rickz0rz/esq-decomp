typedef signed long LONG;
typedef unsigned char UBYTE;

extern LONG NEWGRID_GridOperationId;
extern LONG NEWGRID_OverridePenIndex;

extern LONG GCOMMAND_NicheTextPen;
extern LONG GCOMMAND_NicheFramePen;
extern LONG GCOMMAND_MplexDetailLayoutPen;
extern LONG GCOMMAND_MplexDetailRowPen;
extern LONG GCOMMAND_PpvShowtimesLayoutPen;
extern LONG GCOMMAND_PpvShowtimesRowPen;

LONG NEWGRID_SelectEntryPen(UBYTE *entry)
{
    LONG pen;
    LONG override;
    LONG op;

    pen = -1;

    if (entry != 0) {
        if (entry[41] != (UBYTE)0xFF) {
            pen = (LONG)entry[41];
        } else if ((entry[27] & 0x02) != 0) {
            pen = 4;
        } else if ((entry[27] & 0x40) != 0) {
            pen = 5;
        } else if ((entry[27] & 0x10) != 0) {
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
    if (entry != 0 && entry[42] != (UBYTE)0xFF) {
        override = (LONG)entry[42];
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
