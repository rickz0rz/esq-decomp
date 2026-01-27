; This is wild. So 276(A6) is apparently a pointer to ThisTask (see: http://amigadev.elowar.com/read/ADCD_2.1/Includes_and_Autodocs_2._guide/node0551.html
; and http://amigadev.elowar.com/read/ADCD_2.1/Includes_and_Autodocs_2._guide/node009E.html) ... so the pointer to ThisTask gets pushed into A3, and then
; offset 152 on ThisTask ( http://amigadev.elowar.com/read/ADCD_2.1/Libraries_Manual_guide/node02BB.html ) points to _some_ field... is it the stack pointer
; or something? Need to work on this...

Struct_AnimOb_Size              = 42

Struct_ClockData_Size           = 14
Struct_ClockData__Sec           = 0
Struct_ClockData__Min           = 2
Struct_ClockData__Hour          = 4
Struct_ClockData__MDay          = 6
Struct_ClockData__Month         = 8
Struct_ClockData__Year          = 10
Struct_ClockData__WDay          = 12

Struct_ColorTextFont_Size       = 96

; ExecBase
; http://amigadev.elowar.com/read/ADCD_2.1/Includes_and_Autodocs_2._guide/node009E.html
Struct_ExecBase__ThisTask       = 276
Struct_ExecBase__TaskWait       = 420
Struct_ExecBase__SoftInts       = 434

Struct_InfoData_Size            = 36

Struct_InputEvent_Size          = 22

Struct_Interrupt_Size           = 22

; Disk I/O buffer state (see DISKIO_BufferPtr/DISKIO_BufferSize in data files)
Struct_DiskIoBufferState_Size           = 16
Struct_DiskIoBufferState__BufferPtr     = 0
Struct_DiskIoBufferState__BufferSize    = 4
Struct_DiskIoBufferState__Remaining     = 8
Struct_DiskIoBufferState__SavedF45      = 12

; Disk I/O buffer control (see DISKIO_BufferBase/DISKIO_BufferErrorFlag)
Struct_DiskIoBufferControl_Size         = 8
Struct_DiskIoBufferControl__BufferBase  = 0
Struct_DiskIoBufferControl__ErrorFlag   = 4

Struct_IORequest__io_Message    = 0
Struct_IORequest__io_Command    = 28

Struct_IOStdReq_Size            = 48
Struct_IOStdReq__io_Message     = Struct_IORequest__io_Message
Struct_IOStdReq__io_Command     = Struct_IORequest__io_Command
Struct_IOStdReq__io_Data        = 40

; List
; http://amigadev.elowar.com/read/ADCD_2.1/Includes_and_Autodocs_2._guide/node007D.html
Struct_List_Size                = 14
Struct_List__lh_Head            = 0
Struct_List__lh_Tail            = 4
Struct_List__lh_TailPred        = 8
Struct_List__lh_Type            = 12
Struct_List__l_pad              = 13

; Message and MsgPort
; http://amigadev.elowar.com/read/ADCD_2.1/Includes_and_Autodocs_2._guide/node0099.html
Struct__Message__mn_Node        = 0
Struct__Message__mn_ReplyPort   = 14

Struct_MsgPort__mp_Node         = 0
Struct_MsgPort__mp_Flags        = 14
Struct_MsgPort__mp_SigBit       = 15
Struct_MsgPort__mp_SigTask      = 16

; Node
; http://amigadev.elowar.com/read/ADCD_2.1/Includes_and_Autodocs_3._guide/node062F.html
Struct_Node__ln_Succ            = 0
Struct_Node__ln_Pred            = 4
Struct_Node__ln_Type            = 8
Struct_Node__ln_Pri             = 9
Struct_Node__ln_Name            = 10
NT_MSGPORT      = 4
NT_MESSAGE      = 5

Struct_RastPort__BitMap         = 4
Struct_RastPort__Flags          = 32

Struct_SoftIntList_Size         = 16
Struct_SoftIntList__sh_List     = 0
Struct_SoftIntList__sh_Pad      = 14
