#!/bin/bash

#for at kunne eksikvere scriptet skal der først gøres to ting i terminalen
#1 sed -i -e 's/\r$//' /data/KGAusers/raspau/auto.sh
#2 chmod +x /data/KGAusers/raspau/auto.sh
# scriptet kan nu køres ved input "/data/KGAusers/raspau/auto.sh"

# Check if at least three arguments are provided
if [ "$#" -lt 3 ]; then
  echo "Usage: $0 provide user input: 'WATCH_DIR' 'RUN_FOLDER' 'SAMPLE_SHEET' [--DNA](optional) [--RNA](optional)"
  exit 1
fi

# Assign the arguments to variables
WATCH_DIR=$1
RUN_FOLDER=$2
SAMPLE_SHEET=$3

# Initialize DNA and RNA flags as empty
DNA_FLAG=""
RNA_FLAG=""

# Shift the arguments to check for optional DNA and RNA parameters
shift 3
for arg in "$@"
do
  case $arg in
    --DNA)
    DNA_FLAG="--DNA"
    ;;
    --RNA)
    RNA_FLAG="--RNA"
    ;;
    *)
    echo "Invalid option: $arg"
    echo "Usage: $0 'WATCH_DIR' 'RUN_FOLDER' 'SAMPLE_SHEET' [--DNA] [--RNA]"
    exit 1
    ;;
  esac
done

WATCH_FILE="CopyComplete.txt"
FOUND=0

echo "Script started. Watching for ${WATCH_FILE} in ${WATCH_DIR}"

while [ $FOUND -eq 0 ]; do
  if [ -f "${WATCH_DIR}/${WATCH_FILE}" ]; then
    echo "File ${WATCH_FILE} found in ${WATCH_DIR}. Preparing to start Nextflow..."
    FOUND=1
  else
    echo "File ${WATCH_FILE} not found in ${WATCH_DIR}. Checking again in 10 minutes..."
    sleep 600
  fi
done

# Now that the file is found, run the Nextflow command with the optional flags
echo "Starting Nextflow..."
nextflow run KGVejle/demultiplex -r main --runfolder "${RUN_FOLDER}" --samplesheet "${SAMPLE_SHEET}" ${DNA_FLAG} ${RNA_FLAG}
