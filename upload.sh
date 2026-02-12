#!/bin/bash

## 1. GLOBAL VARIABLES
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$1"
# By default filter for jpg and mp4 files
IFS=',' read -ra EXT_ARRAY <<< "${2:-jpg,mp4}"
TMP_DIR="/tmp/immich_upload_$(date +%s)"

## 2. VALIDATION
# .immich.env 
if [ -f "$SCRIPT_DIR/.immich.env" ]; then
    export $(grep -v '^#' "$SCRIPT_DIR/.immich.env" | xargs)
else
    echo "Error: File $SCRIPT_DIR/.immich.env not found."
    exit 1
fi
# Bad usage
if [ -z "$SOURCE_DIR" ]; then
    echo "Usage: $0 <source_directory> [extensions_comma_separated]"
    exit 1
fi
# immich-go not installed
if ! command -v immich-go &> /dev/null; then
    echo "Error: immich-go is not installed or not in PATH"
    exit 1;
fi
# Can not establish a connection
if ! curl -s --head --request GET "$IMMICH_INSTANCE_URL/server-info/stats" | grep "200 OK" > /dev/null; then
    echo "Error: Could not establish a connection to Immich server at $IMMICH_INSTANCE_URL"
    exit 1;
fi

## 3. FILTeRING TO A TMP DIR
mkdir -p "$TMP_DIR"

echo "Creating symlinks in $TMP_DIR for files in $SOURCE_DIR with extensions: ${EXT_ARRAY[*]}"

# Build the find expression for the specified extensions
FIND_EXPR=()
for i in "${!EXT_ARRAY[@]}"; do
    if [ "$i" -gt 0 ]; then
        FIND_EXPR+=("-o")
    fi
    FIND_EXPR+=("-iname" "*.${EXT_ARRAY[$i]}")
done

echo "Filtering by: "${EXT_ARRAY[*]}""
find "$SOURCE_DIR" -type f \( "${FIND_EXPR[@]}" \) -exec ln -s {} "$TMP_DIR" \;

## 4. UPLOADING DATA
echo "Uploading $(ls -1 $TMP_DIR | wc -l) files"
immich-go upload from-folder \
    --server "$IMMICH_INSTANCE_URL" \
    --api-key "$IMMICH_API_KEY" \
    "$TMP_DIR" > /dev/null

## 5. CLEANING
echo "Cleaning temporary links..."
rm -rf "$TMP_DIR"

echo "Done!"