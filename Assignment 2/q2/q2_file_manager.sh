#!/bin/bash

# this function show the menu options
show_menu() {
    echo ""
    echo "=============================="
    echo "   FILE & DIRECTORY MANAGER  "
    echo "=============================="
    echo "1. List files in current directory"
    echo "2. Create a new directory"
    echo "3. Create a new file"
    echo "4. Delete a file"
    echo "5. Rename a file"
    echo "6. Search for a file"
    echo "7. Count files and directories"
    echo "8. View file permissions"
    echo "9. Copy a file"
    echo "10. Exit"
    echo "=============================="
    echo -n "Enter your choice: "
}

while true; do
    show_menu
    read choice

    case $choice in

        1)
            # list files with sizes and details
            echo ""
            echo "--- Files in $(pwd) ---"
            ls -lh
            ;;

        2)
            # create a new directory
            echo -n "Enter name for new directory: "
            read dirname

            # check if it already exist
            if [ -d "$dirname" ]; then
                echo "[!] That directory already exists!"
            else
                mkdir "$dirname"
                echo "[+] Directory '$dirname' created successfully!"
            fi
            ;;

        3)
            # create a new empty file
            echo -n "Enter name for new file: "
            read filename

            if [ -f "$filename" ]; then
                echo "[!] File '$filename' already exists!"
            else
                touch "$filename"
                echo "[+] File '$filename' created!"
            fi
            ;;

        4)
            # delete a file
            echo -n "Enter the name of file to delete: "
            read filename

            if [ -f "$filename" ]; then
                echo -n "Are you sure you want to delete '$filename'? (yes/no): "
                read confirm

                if [ "$confirm" == "yes" ]; then
                    rm "$filename"
                    echo "[+] File deleted!"
                else
                    echo "[*] Deletion cancelled."
                fi
            else
                echo "[!] File '$filename' not found."
            fi
            ;;

        5)
            # rename a file
            echo -n "Enter the current file name: "
            read old_name

            if [ -f "$old_name" ]; then
                echo -n "Enter the new file name: "
                read new_name
                mv "$old_name" "$new_name"
                echo "[+] Renamed '$old_name' to '$new_name'"
            else
                echo "[!] File '$old_name' does not exist."
            fi
            ;;

        6)
            # search for a file
            echo -n "Enter filename or pattern to search for: "
            read search_name
            echo ""
            echo "--- Search Results ---"
            find . -name "$search_name" 2>/dev/null
            if [ $? -ne 0 ]; then
                echo "[!] Something went wrong with search."
            fi
            ;;

        7)

            file_count=$(find . -maxdepth 1 -type f | wc -l)
            dir_count=$(find . -maxdepth 1 -type d | wc -l)
            dir_count=$((dir_count - 1))

            echo ""
            echo "--- Count Results ---"
            echo "Files in current directory     : $file_count"
            echo "Directories in current folder  : $dir_count"
            ;;

        8)
          
            echo -n "Enter file or directory name: "
            read fname

            if [ -e "$fname" ]; then
                echo ""
                ls -la "$fname"
            else
                echo "[!] '$fname' not found."
            fi
            ;;

        9)
            
            echo -n "Enter source file name: "
            read source_file

            if [ -f "$source_file" ]; then
                echo -n "Enter destination name: "
                read dest_file
                cp "$source_file" "$dest_file"
                echo "[+] File copied from '$source_file' to '$dest_file'"
            else
                echo "[!] Source file '$source_file' does not exist."
            fi
            ;;

        10)
            echo "Thank You"
            exit 0
            ;;

        *)
           
            echo "[!] Invalid choice. Please pick a number from the menu."
            ;;
    esac
done
