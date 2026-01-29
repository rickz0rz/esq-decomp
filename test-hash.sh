#!/bin/bash
FILENAME="$(uuidgen)"

~/Downloads/vasm/vasmm68k_mot -Fhunkexe -o "$FILENAME" -nosym src/Prevue.asm
shasum -a 256 "$FILENAME"
echo "6bd4760d1cf0706297ef169461ed0d7b7f0b079110a78e34d89223499e7c2fa2 [Should be this]"
rm "$FILENAME"
