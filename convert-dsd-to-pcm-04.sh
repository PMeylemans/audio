#!/bin/bash
#
# Filename  :   convert-dsd-to-pcm.sh
#
# Purpose   :   Convert DSD decoded files *.dsf into Flac files
#               88.2 Mhz and 32 bit
#
# Usage     :    ./convert-dsd-to-pcm.sh directory-containing-the-dsd-files
#               a new directory with the same name with _FLAC will be created
#               converted sound tracks will be stored there
#
# History   :   MEY created from ChatGPT



# Check if ffmpeg is installed
if ! command -v ffmpeg &>/dev/null; then
    echo "Error: ffmpeg is not installed. Please install ffmpeg before running this script."
    exit 1
fi

# Check if input folder is provided as an argument
if [ $# -ne 1 ]; then
    echo "Usage: $0 <input_folder>"
    exit 1
fi

input_folder="$1"

# Check if input folder exists
if [ ! -d "$input_folder" ]; then
    echo "Error: Input folder '$input_folder' does not exist."
    exit 1
fi

# Create an output folder for FLAC files
output_folder="${input_folder}_flac"
mkdir -p "$output_folder"

# Find DSF files and process them using xargs
find "$input_folder" -type f -name "*.dsf" -print0 | xargs -0 -P "$(nproc)" -I {} bash -c '
    dsf_file="$1"
    dsf_filename=$(basename "$dsf_file")
    flac_filename="${dsf_filename%.dsf}.flac"
    flac_filepath="$2/$flac_filename"

    ffmpeg -i "$dsf_file" -sample_fmt s32 -ar 88200 -acodec flac "$flac_filepath" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "Converted: $dsf_filename -> $flac_filename"
    else
        echo "Error converting: $dsf_filename"
    fi
' _ {} "$output_folder"

echo "Conversion completed. FLAC files are saved in: $output_folder"
