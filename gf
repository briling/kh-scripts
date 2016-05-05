#!/bin/bash

f=${1/\.out/}
if [ ! -e $f.out ]          ; then echo 'file?' ; exit 1 ; fi
if ! grep -q 'freq>' $f.out ; then echo 'freq?' ; exit 1 ; fi
sed -n -e '/freq>/s/freq>//p' $f.out > $f.molden

