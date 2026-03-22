#ifndef WDISP_ACCUMULATOR_ROWS_H
#define WDISP_ACCUMULATOR_ROWS_H

#include <exec/types.h>

typedef struct WDISP_AccumulatorRow {
    WORD metadata;
    WORD value;
    WORD moveFlags;
    UBYTE copperIndexStart;
    UBYTE copperIndexEnd;
} WDISP_AccumulatorRow;

extern WDISP_AccumulatorRow WDISP_AccumulatorRowTable[];

#endif
