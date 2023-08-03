#!/bin/bash
main() {
    # Create header
    echo "─────────────────────────────────"
    date
    echo "─────────────────────────────────"

    # Run copy command
    rsync -avt /mnt/Seagate/ /mnt/SeagateBackup/
    echo 
}

main "$@"
