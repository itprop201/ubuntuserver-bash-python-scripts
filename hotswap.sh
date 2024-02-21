#!/bin/bash
for i in /sys/class/scsi_host/host*; do
echo "- - -" > $i/scan;
done
mount -a
