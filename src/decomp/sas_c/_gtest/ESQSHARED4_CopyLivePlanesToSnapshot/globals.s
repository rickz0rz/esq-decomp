    XDEF    ESQSHARED_LivePlaneBase0
    XDEF    _ESQSHARED_LivePlaneBase0
    XDEF    ESQSHARED_LivePlaneBase1
    XDEF    _ESQSHARED_LivePlaneBase1
    XDEF    ESQSHARED_LivePlaneBase2
    XDEF    _ESQSHARED_LivePlaneBase2
    XDEF    ESQPARS2_BannerSnapshotPlane0DstPtr
    XDEF    _ESQPARS2_BannerSnapshotPlane0DstPtr
    XDEF    ESQPARS2_BannerSnapshotPlane1DstPtr
    XDEF    _ESQPARS2_BannerSnapshotPlane1DstPtr
    XDEF    ESQPARS2_BannerSnapshotPlane2DstPtr
    XDEF    _ESQPARS2_BannerSnapshotPlane2DstPtr
    SECTION data,DATA
ESQSHARED_LivePlaneBase0:
_ESQSHARED_LivePlaneBase0:
    DS.L    1
ESQSHARED_LivePlaneBase1:
_ESQSHARED_LivePlaneBase1:
    DS.L    1
ESQSHARED_LivePlaneBase2:
_ESQSHARED_LivePlaneBase2:
    DS.L    1
* the three dst pointers MUST be contiguous: the ASM walks them via (A2)+
ESQPARS2_BannerSnapshotPlane0DstPtr:
_ESQPARS2_BannerSnapshotPlane0DstPtr:
    DS.L    1
ESQPARS2_BannerSnapshotPlane1DstPtr:
_ESQPARS2_BannerSnapshotPlane1DstPtr:
    DS.L    1
ESQPARS2_BannerSnapshotPlane2DstPtr:
_ESQPARS2_BannerSnapshotPlane2DstPtr:
    DS.L    1
    END
