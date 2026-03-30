BEGIN{
    setapen_calls=0
    setdrmd_calls=0
    move_calls=0
    text_calls=0
    display_calls=0
    h_rts=0
    event_count=0
    text_count=0
    display_count=0
}

function t(s, x){
    x=s
    sub(/;.*/,"",x)
    sub(/^[ \t]+/,"",x)
    sub(/[ \t]+$/,"",x)
    gsub(/[ \t]+/," ",x)
    return toupper(x)
}

function remember(line,    i){
    for(i=1;i<8;i++) hist[i]=hist[i+1]
    hist[8]=line
}

function normalize_sym(sym){
    gsub(/\(A4\)/,"",sym)
    if(sym ~ /^GLOBAL_STR_VIN_BCK_FWD_SSPD_AD_L/) return "GLOBAL_STR_VIN_BCK_FWD_SSPD_AD_LINE"
    if(sym ~ /^ESQ_STR_SATELLITE_DELIVERED_SCRO/) return "ESQ_STR_SATELLITE_DELIVERED_SCROLL_SPEED"
    return sym
}

function find_recent_symbol(    i, m, sym){
    for(i=8;i>=1;i--){
        if(hist[i] ~ /^PEA /){
            sym=hist[i]
            sub(/^PEA /,"",sym)
            if(sym ~ /^[A-Z_][A-Z0-9_]*(\(A4\))?$/){
                return normalize_sym(sym)
            }
        }
        if(hist[i] ~ /^LEA [A-Z0-9_]+,A0$/){
            sym=hist[i]
            sub(/^LEA /,"",sym)
            sub(/,A0$/,"",sym)
            return normalize_sym(sym)
        }
    }
    return "UNKNOWN"
}

function push_event(kind){
    event_count++
    events[event_count]=kind
}

{
    l=t($0)
    if(l=="") next

    if(l ~ /(JSR|BSR).*_LVOSETAPEN/){
        setapen_calls++
        push_event("SETAPEN")
    }
    if(l ~ /(JSR|BSR).*_LVOSETDRMD/){
        setdrmd_calls++
        push_event("SETDRMD")
    }
    if(l ~ /(JSR|BSR).*_LVOMOVE/){
        move_calls++
        push_event("MOVE")
    }
    if(l ~ /(JSR|BSR).*_LVOTEXT/){
        text_calls++
        text_count++
        text_syms[text_count]=find_recent_symbol()
        push_event("TEXT")
    }
    if(l ~ /(JSR|BSR).*DISPLIB_DISPLAYTEXTATPOSITION/){
        display_calls++
        display_count++
        display_syms[display_count]=find_recent_symbol()
        push_event("DISPLAY")
    }
    if(l=="RTS"){
        h_rts=1
        push_event("RTS")
    }

    remember(l)
}

END{
    expected_event_count=29
    split("SETAPEN SETDRMD DISPLAY DISPLAY SETAPEN MOVE TEXT MOVE TEXT MOVE TEXT MOVE TEXT MOVE TEXT MOVE TEXT MOVE TEXT MOVE TEXT MOVE TEXT MOVE TEXT MOVE TEXT SETAPEN RTS", expected_events, " ")
    split("GLOBAL_STR_VIN_BCK_FWD_SSPD_AD_LINE GLOBAL_STR_TZ_DST_CONT_TXT_GRPH", expected_displays, " ")
    split("ED_DIAGVINMODECHAR ESQ_STR_B ESQ_STR_E ESQ_STR_SATELLITE_DELIVERED_SCROLL_SPEED ESQ_TAG_36 ED_DIAGSCROLLSPEEDCHAR ESQ_STR_6 ESQ_SECONDARYSLOTMODEFLAGCHAR ESQ_STR_Y ED_DIAGTEXTMODECHAR ED_DIAGGRAPHMODECHAR", expected_texts, " ")

    events_ok = (event_count == expected_event_count)
    if(events_ok){
        for(i=1;i<=expected_event_count;i++){
            if(events[i] != expected_events[i]){
                events_ok=0
                break
            }
        }
    }

    displays_ok = (display_count == 2)
    if(displays_ok){
        for(i=1;i<=2;i++){
            if(display_syms[i] != expected_displays[i]){
                displays_ok=0
                break
            }
        }
    }

    texts_ok = (text_count == 11)
    if(texts_ok){
        for(i=1;i<=11;i++){
            if(text_syms[i] != expected_texts[i]){
                texts_ok=0
                break
            }
        }
    }

    print "HAS_SETAPEN="(setapen_calls==3?1:0)
    print "HAS_SETDRMD="(setdrmd_calls==1?1:0)
    print "HAS_MOVE="(move_calls==11?1:0)
    print "HAS_TEXT="(text_calls==11?1:0)
    print "HAS_DISPLAY="(display_calls==2?1:0)
    print "EVENT_SEQUENCE_OK="events_ok
    print "DISPLAY_SEQUENCE_OK="displays_ok
    print "TEXT_SEQUENCE_OK="texts_ok
    print "HAS_RTS="h_rts
}
