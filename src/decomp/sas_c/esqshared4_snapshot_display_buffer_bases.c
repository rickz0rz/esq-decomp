#include <exec/types.h>
extern ULONG ESQSHARED_LivePlaneBase0;
extern ULONG ESQSHARED_LivePlaneBase1;
extern ULONG ESQSHARED_LivePlaneBase2;

extern ULONG ESQPARS2_SnapshotLivePlane0Base;
extern ULONG ESQPARS2_SnapshotLivePlane1Base;
extern ULONG ESQPARS2_SnapshotLivePlane2Base;

void ESQSHARED4_SnapshotDisplayBufferBases(void)
{
    ESQPARS2_SnapshotLivePlane0Base = ESQSHARED_LivePlaneBase0;
    ESQPARS2_SnapshotLivePlane1Base = ESQSHARED_LivePlaneBase1;
    ESQPARS2_SnapshotLivePlane2Base = ESQSHARED_LivePlaneBase2;
}
