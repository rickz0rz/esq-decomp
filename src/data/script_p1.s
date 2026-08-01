    XDEF    _TEXTDISP_LastDispatchGroupId
    XDEF    _TEXTDISP_CommandBufferPtr
    XDEF    _TEXTDISP_CommandPrefixFormat
_TEXTDISP_LastDispatchGroupId:
    DC.B    0,"1"
_TEXTDISP_CommandBufferPtr:
    DS.L    1
_TEXTDISP_CommandPrefixFormat:
    NStr3   "xx%s",18,"TEMPO"
