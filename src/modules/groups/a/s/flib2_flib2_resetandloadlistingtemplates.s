    XDEF    _FLIB2_ResetAndLoadListingTemplates


;------------------------------------------------------------------------------
; FUNC: _FLIB2_ResetAndLoadListingTemplates   (Routine at _FLIB2_ResetAndLoadListingTemplates)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A0
; CALLS:
;   GCOMMAND_LoadDefaultTable, GCOMMAND_LoadMplexTemplate, GCOMMAND_LoadPPV3Template, _FLIB2_LoadDigitalNicheDefaults, _FLIB2_LoadDigitalMplexDefaults, _FLIB2_LoadDigitalPpvDefaults
; READS:
;   (none observed)
; WRITES:
;   _GCOMMAND_DigitalNicheListingsTemplatePtr, _GCOMMAND_MplexListingsTemplatePtr, _GCOMMAND_MplexAtTemplatePtr, _GCOMMAND_PPVListingsTemplatePtr, _GCOMMAND_PPVPeriodTemplatePtr
; DESC:
;   Clears template pointers, loads fallback defaults, then loads disk-backed
;   templates for Niche/Mplex/PPV.
; NOTES:
;   This is the top-level population entry point for listing-template globals.
;------------------------------------------------------------------------------
_FLIB2_ResetAndLoadListingTemplates:
    SUBA.L  A0,A0
    MOVE.L  A0,_GCOMMAND_DigitalNicheListingsTemplatePtr
    MOVE.L  A0,_GCOMMAND_MplexListingsTemplatePtr
    MOVE.L  A0,_GCOMMAND_MplexAtTemplatePtr
    MOVE.L  A0,_GCOMMAND_PPVListingsTemplatePtr
    MOVE.L  A0,_GCOMMAND_PPVPeriodTemplatePtr
    BSR.W   _FLIB2_LoadDigitalNicheDefaults

    BSR.W   _FLIB2_LoadDigitalMplexDefaults

    BSR.W   _FLIB2_LoadDigitalPpvDefaults

    BSR.W   GCOMMAND_LoadDefaultTable

    BSR.W   GCOMMAND_LoadMplexTemplate

    BSR.W   GCOMMAND_LoadPPV3Template

    RTS
