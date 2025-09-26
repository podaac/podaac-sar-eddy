#!/bin/bash

# Script to create tar.gz archives for each .tif file in data/processed
# Each archive includes the .tif file and corresponding .png preview

set -e

PROCESSED_DIR="data/processed"
PREVIEW_DIRS=("data/previews")

if [ ! -d "$PROCESSED_DIR" ]; then
    echo "Error: $PROCESSED_DIR directory not found"
    exit 1
fi

# Find all .tif files in processed directory
tif_files=$(find "$PROCESSED_DIR" -name "*.tif" -type f)

if [ -z "$tif_files" ]; then
    echo "No .tif files found in $PROCESSED_DIR"
    exit 0
fi

echo "Found .tif files:"
echo "$tif_files"
echo

# Process each .tif file
while IFS= read -r tif_file; do
    # Extract filename without path and extension
    basename_tif=$(basename "$tif_file" .tif)

    echo "Processing: $basename_tif"

    # Look for corresponding PNG file in preview directories
    png_file=""
    for preview_dir in "${PREVIEW_DIRS[@]}"; do
        # Try different PNG naming patterns
        for pattern in "${basename_tif}.png" "${basename_tif}_preview.png"; do
            candidate="$preview_dir/$pattern"
            if [ -f "$candidate" ]; then
                png_file="$candidate"
                break 2
            fi
        done
    done

    if [ -z "$png_file" ]; then
        echo "  Warning: No corresponding PNG file found for $basename_tif"
        echo "  Creating archive with .tif file only"
        tar -czf "${basename_tif}.tar.gz" -C "$(dirname "$tif_file")" "$(basename "$tif_file")"
    else
        echo "  Found PNG: $png_file"
        # Create temporary directory structure
        temp_dir=$(mktemp -d)

        # Create the directory structure in temp
        mkdir -p "$temp_dir/data/processed"
        mkdir -p "$temp_dir/$(dirname "$png_file")"

        # Copy files to temp structure
        cp "$tif_file" "$temp_dir/data/processed/"
        cp "$png_file" "$temp_dir/$png_file"

        # Create tar.gz archive maintaining directory structure
        tar -czf "${basename_tif}.tar.gz" -C "$temp_dir" .

        # Clean up temp directory
        rm -rf "$temp_dir"
    fi

    echo "  Created: ${basename_tif}.tar.gz"
    echo
done <<< "$tif_files"

echo "Archive creation complete!"
