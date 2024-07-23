#!/bin/zsh
#From arch wiki: https://wiki.archlinux.org/title/PCI_passthrough_via_OVMF#Ensuring_that_the_groups_are_valid 
rm output.txt
shopt -s nullglob
for g in $(find /sys/kernel/iommu_groups/* -maxdepth 0 -type d | sort -V); do
    echo "IOMMU Group ${g##*/}:" >> output.txt
    for d in $g/devices/*; do
        echo -e "\t$(lspci -nns ${d##*/})" >> output.txt
    done;
done; 

cat output.txt
echo "Output saved to output.txt"
