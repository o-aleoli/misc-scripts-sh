#!/bin/bash
# Conversion and compression of MP4 files to WhatsApp compatible MP4.
#
# From left to right, each arg's role:
# video codec: H.264
# bitrate: 500 kbps
# most basic H.264 baseline for compatibility
# level 3.0 for compatibility
# QuickTime compatibility
#
# Alexandre Olivieri (olivieri.alexandre0@gmail.com)

echo -n "Input .mp4 file: "
read input
echo -n "Output .mp4 file: "
read output

ffmpeg -i $input.mp4 -c:v libx264 -b:v 0.5M -profile:v baseline -level 3.0 -pix_fmt yuv420p $output.mp4
