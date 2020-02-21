#!/bin/bash
# Calculates the surface energy according to doi:10.1103/PhysRevB.76.155439

atype="NbO3"
aE0surf=`sed -E 's/([+-]?[0-9.]+)[eE]\+?(-?)([0-9]+)/(\1*10^\2\3)/g' <<< $(awk '/E0=/ { print $5;exit; }' a/OSZICAR)`
aEsurf=`sed -E 's/([+-]?[0-9.]+)[eE]\+?(-?)([0-9]+)/(\1*10^\2\3)/g' <<< $(awk '/E0=/ { a=$5 } END{ print a }' a/OSZICAR)`
aS=`echo $(awk 'NR==4' a/CONTCAR | awk '{ print $2 }')'*'$(awk 'NR==5' a/CONTCAR | awk '{ print $3 }') | bc -l`
btype="complementar de NbO3"
bE0surf=`sed -E 's/([+-]?[0-9.]+)[eE]\+?(-?)([0-9]+)/(\1*10^\2\3)/g' <<< $(awk '/E0=/ { print $5;exit; }' b/OSZICAR)`
bEsurf=`sed -E 's/([+-]?[0-9.]+)[eE]\+?(-?)([0-9]+)/(\1*10^\2\3)/g' <<< $(awk '/E0=/ { a=$5 } END{ print a }' b/OSZICAR)`
bS=`echo $(awk 'NR==4' b/CONTCAR | awk '{ print $2 }')'*'$(awk 'NR==5' b/CONTCAR | awk '{ print $3 }') | bc -l`
bulkE=`sed -E 's/([+-]?[0-9.]+)[eE]\+?(-?)([0-9]+)/(\1*10^\2\3)/g' <<< $(awk '/E0=/ { a=$0 } END{ print a }' ../bulk/1x1x1/OSZICAR | awk '{ print $5 }')`
n=9

Ecleaved=`echo '0.25*('$aE0surf'+'$bE0surf'-'$n'*'$bulkE')' | bc -l`
aDEsurf=`echo '0.5*('$aEsurf'-'$aE0surf')' | bc -l`
bDEsurf=`echo '0.5*('$bEsurf'-'$bE0surf')' | bc -l`
agamma=`echo '('$Ecleaved'+'$aDEsurf')/'$aS | bc -l`
bgamma=`echo '('$Ecleaved'+'$bDEsurf')/'$bS | bc -l`

touch ./surfEnergy.txt

cat > ./surfEnergy.txt <<!
unidades de bulk que formam o sistema antes de clivar = $n
energia de clivagem = $Ecleaved eV
energia do bulk = $(echo $bulkE | bc -l) eV
###############################################################################
$atype
área de superfície = $aS A²
energia total sem relaxar = $(echo $aE0surf | bc -l) eV
energia total relaxada = $(echo $aEsurf | bc -l) eV
energia liberada no relaxamento = $aDEsurf eV
energia superficial = $agamma eV A⁻²
                    = $(echo '16.02176634*'$agamma | bc -l) J m⁻²
###############################################################################
$btype
área de superfície = $bS A²
energia total sem relaxar = $(echo $bE0surf | bc -l) eV
energia total relaxada = $(echo $bEsurf | bc -l) eV
energia liberada no relaxamento = $bDEsurf eV
energia superficial = $bgamma eV A⁻²
                    = $(echo '16.02176634*'$bgamma | bc -l) J m⁻²
!

