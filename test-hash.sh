#!/bin/bash
UUID=$(uuidgen)
FILENAME="ESQ-3-$UUID.bin"

~/Downloads/vasm/vasmm68k_mot -Fhunkexe -o "$FILENAME" -nosym ESQ-3-Test.asm
shasum -a 256 "$FILENAME"
echo "573ace0c5d52c71d966a782a87eefc09a5d53ac42ac4ff68ac96f0ffbf17e192 [Should be this]"
rm "$FILENAME"