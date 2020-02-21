#!/bin/bash

OUTPUTFILE="deforETOT.dat"
DIRECTORIES=(c5 c4 c3 c2 c1 relax t1 t2 t3 t4)

touch $OUTPUTFILE

for i in "${DIRECTORIES[@]}"
do
    E=`awk '/TOTEN/ { a=$0 } END{ print a }' $i/OUTCAR | awk '{ print $--NF}'`
    V=`awk '/volume of cell :/ { a=$0 } END{ print a }' $i/OUTCAR | awk '{ print $NF }'`
    echo "$V   $E" >> $OUTPUTFILE
done
