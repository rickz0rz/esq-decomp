#include <exec/types.h>
extern LONG NEWGRID_ModeSelectionTable[7];
extern LONG NEWGRID_ModeCycleCountdown;
extern LONG NEWGRID_ModeCandidateIndex;

extern UBYTE CONFIG_ModeCycleEnabledFlag;
extern LONG CONFIG_ModeCycleGateDuration;

extern BYTE CONFIG_NicheModeCycleBudget_Y;
extern BYTE CONFIG_NicheModeCycleBudget_Static;
extern BYTE CONFIG_NicheModeCycleBudget_Custom;

extern LONG GCOMMAND_NicheModeCycleCount;
extern LONG GCOMMAND_MplexModeCycleCount;
extern LONG GCOMMAND_PpvModeCycleCount;

extern BYTE NEWGRID_NicheModeCycleBudget_Y;
extern BYTE NEWGRID_NicheModeCycleBudget_Static;
extern BYTE NEWGRID_NicheModeCycleBudget_Custom;
extern BYTE NEWGRID_NicheModeCycleBudget_Global;
extern BYTE NEWGRID_MplexModeCycleBudget;
extern BYTE NEWGRID_PpvModeCycleBudget;

LONG NEWGRID_SelectNextMode(void)
{
    LONG modeTable[7];
    LONG modeAccepted;
    LONG selectedMode;
    LONG cycleStartIndex;
    LONG i;

    modeAccepted = 0;
    selectedMode = 0;
    cycleStartIndex = 0;

    for (i = 0; i < 7; ++i) {
        modeTable[i] = NEWGRID_ModeSelectionTable[i];
    }

    if (CONFIG_ModeCycleEnabledFlag == 'Y') {
        LONG cycleGate = CONFIG_ModeCycleGateDuration;

        if (cycleGate <= 0) {
            selectedMode = 12;
            modeAccepted = 1;
        } else if (NEWGRID_ModeCycleCountdown > 0) {
            NEWGRID_ModeCycleCountdown -= 1;
            selectedMode = 12;
            modeAccepted = 1;
        } else {
            cycleStartIndex = NEWGRID_ModeCandidateIndex;
            NEWGRID_ModeCycleCountdown = cycleGate;
        }
    }

    for (;;) {
        if ((WORD)modeAccepted != 0) {
            return selectedMode;
        }

        {
            LONG idx = NEWGRID_ModeCandidateIndex;
            selectedMode = modeTable[idx];
            if (selectedMode == 12) {
                NEWGRID_ModeCandidateIndex = 0;
            } else {
                NEWGRID_ModeCandidateIndex = idx + 1;
            }
        }

        if (CONFIG_ModeCycleEnabledFlag == 'Y') {
            LONG key = selectedMode - 5;
            modeAccepted = 0;

            if (key >= 0 && key < 8) {
                switch (key) {
                case 0:
                    modeAccepted = (GCOMMAND_NicheModeCycleCount != 0) ? -1 : 0;
                    break;
                case 1:
                    modeAccepted = (CONFIG_NicheModeCycleBudget_Y != 0) ? -1 : 0;
                    break;
                case 2:
                    modeAccepted = (CONFIG_NicheModeCycleBudget_Static != 0) ? -1 : 0;
                    break;
                case 3:
                    modeAccepted = (CONFIG_NicheModeCycleBudget_Custom != 0) ? -1 : 0;
                    break;
                case 4:
                    modeAccepted = (GCOMMAND_MplexModeCycleCount != 0) ? -1 : 0;
                    break;
                case 5:
                    modeAccepted = (GCOMMAND_PpvModeCycleCount != 0) ? -1 : 0;
                    break;
                default:
                    break;
                }
            }

            if ((WORD)modeAccepted != 0) {
                continue;
            }

            if (NEWGRID_ModeCandidateIndex != cycleStartIndex) {
                continue;
            }

            selectedMode = 12;
            modeAccepted = 1;
            continue;
        }

        {
            LONG key = selectedMode - 5;
            modeAccepted = 0;

            if (key < 0 || key >= 8) {
                continue;
            }

            switch (key) {
            case 0: {
                LONG budgetResetValue = GCOMMAND_NicheModeCycleCount;
                if (budgetResetValue > 0) {
                    NEWGRID_NicheModeCycleBudget_Global -= 1;
                    if (NEWGRID_NicheModeCycleBudget_Global <= 0) {
                        modeAccepted = 1;
                    }
                }
                if ((WORD)modeAccepted != 0) {
                    NEWGRID_NicheModeCycleBudget_Global = (BYTE)budgetResetValue;
                }
                break;
            }

            case 1: {
                BYTE budgetResetValue = CONFIG_NicheModeCycleBudget_Y;
                if (budgetResetValue > 0) {
                    NEWGRID_NicheModeCycleBudget_Y -= 1;
                    if (NEWGRID_NicheModeCycleBudget_Y <= 0) {
                        modeAccepted = 1;
                    }
                }
                if ((WORD)modeAccepted != 0) {
                    NEWGRID_NicheModeCycleBudget_Y = budgetResetValue;
                }
                break;
            }

            case 2: {
                BYTE budgetResetValue = CONFIG_NicheModeCycleBudget_Static;
                if (budgetResetValue > 0) {
                    NEWGRID_NicheModeCycleBudget_Static -= 1;
                    if (NEWGRID_NicheModeCycleBudget_Static <= 0) {
                        modeAccepted = 1;
                    }
                }
                if ((WORD)modeAccepted != 0) {
                    NEWGRID_NicheModeCycleBudget_Static = budgetResetValue;
                }
                break;
            }

            case 3: {
                BYTE budgetResetValue = CONFIG_NicheModeCycleBudget_Custom;
                if (budgetResetValue > 0) {
                    NEWGRID_NicheModeCycleBudget_Custom -= 1;
                    if (NEWGRID_NicheModeCycleBudget_Custom <= 0) {
                        modeAccepted = 1;
                    }
                }
                if ((WORD)modeAccepted != 0) {
                    NEWGRID_NicheModeCycleBudget_Custom = budgetResetValue;
                }
                break;
            }

            case 4: {
                LONG budgetResetValue = GCOMMAND_MplexModeCycleCount;
                if (budgetResetValue > 0) {
                    NEWGRID_MplexModeCycleBudget -= 1;
                    if (NEWGRID_MplexModeCycleBudget <= 0) {
                        modeAccepted = 1;
                    }
                }
                if ((WORD)modeAccepted != 0) {
                    NEWGRID_MplexModeCycleBudget = (BYTE)budgetResetValue;
                }
                break;
            }

            case 5: {
                LONG budgetResetValue = GCOMMAND_PpvModeCycleCount;
                if (budgetResetValue > 0) {
                    NEWGRID_PpvModeCycleBudget -= 1;
                    if (NEWGRID_PpvModeCycleBudget <= 0) {
                        modeAccepted = 1;
                    }
                }
                if ((WORD)modeAccepted != 0) {
                    NEWGRID_PpvModeCycleBudget = (BYTE)budgetResetValue;
                }
                break;
            }

            case 7:
                modeAccepted = 1;
                break;

            default:
                break;
            }
        }
    }
}
