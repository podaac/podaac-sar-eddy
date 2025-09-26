#!/bin/bash

# Script to generate JPL SLICE eddy format names from Sentinel-1 archive filenames
# Input format: S1A_IW_GRDH_1SDV_20190101T142256_20190101T142321_025285_02CBF8_15F9.tar.gz
# Output format: jplslice_eddy_{create_time}_{process_time}_{id}.tar.gz

set -e

# Function to generate new name from a single filename
generate_name() {
    local input_file="$1"

    # Extract basename without .tar.gz extension
    local basename=$(basename "$input_file" .tar.gz)

    # Parse Sentinel-1 filename using regex
    # Pattern: S1[AB]_IW_GRDH_1SDV_{start_time}_{stop_time}_{orbit}_{datatake}_{id}
    if [[ $basename =~ ^S1[AB]_IW_GRDH_1SDV_([0-9]{8}T[0-9]{6})_([0-9]{8}T[0-9]{6})_([0-9]{6})_([0-9A-F]{6})_([0-9A-F]{4})$ ]]; then
        local create_time="${BASH_REMATCH[1]}"
        local stop_time="${BASH_REMATCH[2]}"
        local orbit="${BASH_REMATCH[3]}"
        local datatake="${BASH_REMATCH[4]}"
        local id="${BASH_REMATCH[5]}"

        # Get current UTC time in the same format
        local process_time=$(date -u +"%Y%m%dT%H%M%S")

        # Create new filename
        local new_filename="jplslice_eddy_${id}_${create_time}_${process_time}_1.tar.gz"

        echo "$new_filename"
    else
        echo "Error: File '$input_file' does not match expected Sentinel-1 format" >&2
        echo "Expected format: S1[AB]_IW_GRDH_1SDV_YYYYMMDDTHHMMSS_YYYYMMDDTHHMMSS_NNNNNN_NNNNNN_NNNN.tar.gz" >&2
        return 1
    fi
}

# Main script logic
if [ $# -eq 0 ]; then
    echo "Usage: $0 <filename.tar.gz>"
    echo
    echo "Generates JPL SLICE eddy format name from Sentinel-1 archive filename:"
    echo "  Input:  S1A_IW_GRDH_1SDV_20190101T142256_20190101T142321_025285_02CBF8_15F9.tar.gz"
    echo "  Output: jplslice_eddy_15f9_20190101T142256_YYYYMMDDTHHMMSS_1.tar.gz"
    exit 1
fi
generate_name "$1"
