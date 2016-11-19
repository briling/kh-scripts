#!/bin/bash
f=${1/\.out}
k=${2:-0}
OUT=$f.scan$k.in

if [ ! -e $f.out ]          ; then echo 'file?' ; exit 1 ; fi
if ! grep -q 'SCAN>' $f.out ; then echo 'mol?'  ; exit 1 ; fi
if [   -e $OUT ]            ; then echo 'file!' ; exit 1 ; fi

lines=$(grep -c SCAN $f.out)
mols=$(grep SCAN $f.out | grep -c mol)
n=$(($lines / $mols))

bra=$(($k*$n+1))
ket=$(($bra+$n-1))

if [ -e $f.in ] ; then
  sed -n -e '/$molecule/q' -e p  $f.in  > $OUT
fi
sed -n -e '/MOL>/s/MOL>//p' $f.out | sed -n "$bra,$ket"p >> $OUT
