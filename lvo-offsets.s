; system
AbsExecBase         = 4

; diskfont.library
_LVOOpenDiskFont    = -30

; dos.library
_LVOOpen            = -30
_LVOClose           = -36
_LVORead            = -42
_LVOWrite           = -48
_LVOInput           = -54
_LVOOutput          = -60
_LVOSeek            = -66
_LVODeleteFile      = -72
_LVOLock            = -84
_LVOUnLock          = -90
_LVOCurrentDir      = -126
_LVOIoErr           = -132
ACCESS_READ         = -2

; exec.library
_LVOSupervisor      = -30
_LVOexecPrivate1    = -36
_LVOexecPrivate2    = -42
_LVOexecPrivate3    = -48
_LVOexecPrivate4    = -54
_LVODisable         = -120
_LVOEnable          = -126
_LVOForbid          = -132
_LVOPermit          = -138
_LVOSetIntVector    = -162
_LVOAddIntVector    = -168
_LVORemIntServer    = -174
_LVOAllocMem        = -198
_LVOFreeMem         = -210
_LVOAvailMem        = -216
_LVOAllocEntry      = -222
_LVOFindTask        = -294
_LVOSetSignal       = -306
_LVOAllocSignal     = -330
_LVOFreeSignal      = -336
_LVOAddPort         = -354
_LVORemPort         = -360
_LVOPutMsg          = -366
_LVOGetMsg          = -372
_LVOReplyMsg        = -378
_LVOWaitPort        = -384
_LVOCloseLibrary    = -414
_LVOSetFunction     = -420
_LVOOpenDevice      = -444
_LVOCloseDevice     = -450
_LVODoIO            = -456
_LVOOpenResource    = -498
_LVORawDoFmt        = -522
_LVOOpenLibrary     = -552
_LVOCopyMem         = -624
_LVOColdReboot      = -726

; graphics.library
_LVOTextLength      = -54
_LVOText            = -60
_LVOSetFont         = -66
_LVOOpenFont        = -72
_LVOCloseFont       = -78
_LVOInitRastPort    = -198
_LVOSetRast         = -234
_LVOMove            = -240
_LVODraw            = -246
_LVOBltClear		= -300
_LVORectFill        = -306
_LVOReadPixel       = -318
_LVOSetAPen         = -342
_LVOSetBPen         = -348
_LVOSetDrMd         = -354
_LVOVBeamPos        = -384
_LVOInitBitMap      = -390
_LVOAllocRaster     = -492
_LVOFreeRaster      = -498

; intuition.library
_LVODisplayAlert    = -90
_LVOSizeWindow      = -288
_LVORemakeDisplay   = -384
_LVOAutoRequest     = -348

; utility.library
_LVOAmiga2Date      = -120
_LVODate2Amiga      = -126
_LVOCheckDate       = -132

; battclock.resource
; http://amiga-dev.wikidot.com/resource:battclock
_LVOResetBattClock  = -6
_LVOReadBattClock   = -12
_LVOWriteBattClock  = -18