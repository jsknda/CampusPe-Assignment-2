#!/bin/bash

echo ""
echo "==============================="
echo "   AUTOMATED BACKUP SCRIPT    "
echo "==============================="
echo ""


echo -n "Enter directory to backup: "
read source_dir


if [ ! -d "$source_dir" ]; then
    echo "[!] The directory '$source_dir' does not exist. Exiting."
    exit 1
fi


echo -n "Enter backup destination folder: "
read dest_dir


if [ ! -d "$dest_dir" ]; then
    echo "[*] Destination folder doesn't exist, creating it..."
    mkdir -p "$dest_dir"
    echo "[+] Created: $dest_dir"
fi


echo ""
echo "Backup Type:"
echo "  1. Simple copy (just copies the folder)"
echo "  2. Compressed archive (.tar.gz)"
echo -n "Enter choice (1 or 2): "
read backup_type


# format: YYYYMMDD_HHMMSS
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_NAME="backup_${TIMESTAMP}"

echo ""
echo "[*] Starting backup..."
echo "[*] Source      : $source_dir"
echo "[*] Destination : $dest_dir"

START_TIME=$(date +%s)

if [ "$backup_type" == "1" ]; then
    echo "[*] Doing a simple copy..."
    cp -r "$source_dir" "$dest_dir/$BACKUP_NAME"

    
    if [ $? -eq 0 ]; then
        echo ""
        echo "Backup completed successfully!"
        BACKUP_PATH="$dest_dir/$BACKUP_NAME"
        SIZE=$(du -sh "$BACKUP_PATH" | awk '{print $1}')
    else
        echo "[!] Backup failed!"
        exit 1
    fi

elif [ "$backup_type" == "2" ]; then
    echo "[*] Creating compressed archive..."
    ARCHIVE_NAME="${BACKUP_NAME}.tar.gz"

    tar -czf "$dest_dir/$ARCHIVE_NAME" "$source_dir"

    if [ $? -eq 0 ]; then
        echo ""
        echo "Backup completed successfully!"
        BACKUP_PATH="$dest_dir/$ARCHIVE_NAME"
        SIZE=$(du -sh "$BACKUP_PATH" | awk '{print $1}')
    else
        echo "[!] Backup failed! Something went wrong with tar."
        exit 1
    fi

else
    echo "[!] Invalid choice. Please run the script again and enter 1 or 2."
    exit 1
fi

END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

echo ""
echo "--- Backup Details ---"
if [ "$backup_type" == "2" ]; then
    echo "  File     : $ARCHIVE_NAME"
else
    echo "  Folder   : $BACKUP_NAME"
fi
echo "  Location  : $dest_dir"
echo "  Size      : $SIZE"
echo "  Time taken: $DURATION seconds"
echo ""

echo "[*] Checking old backups (keeping max 5)..."
backup_count=$(ls -1 "$dest_dir" | grep "^backup_" | wc -l)
if [ "$backup_count" -gt 5 ]; then
    echo "[*] Found $backup_count backups, removing old ones..."
    ls -1t "$dest_dir" | grep "^backup_" | tail -n +6 | while read old_backup; do
        rm -rf "$dest_dir/$old_backup"
        echo "   Deleted old backup: $old_backup"
    done
fi

LOG_FILE="backup_history.log"
echo "[$TIMESTAMP] Backed up $source_dir to $dest_dir | Size: $SIZE | Time: ${DURATION}s" >> "$LOG_FILE"
echo "[*] Logged to $LOG_FILE"
echo ""
