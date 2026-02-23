                                                #CampusPe Cybersecurity

	                                             ##Assignment 2

> **Course:** Introduction to Bash Scripting & Linux Automation  
> **Track:** Cybersecurity  
> **Platform:** Ubuntu / Kali Linux

---


## 📖 About This Assignment

This repository contains all five bash scripting solutions developed for the
CampusPe Cybersecurity assignment. The assignment covers core Linux
automation skills including file operations, text processing, log analysis,
backup automation, and user account management.

---

## 📁 Folder Structure

```
bash-scripting-assignment/
│
├── q1_system_info.sh       # Question 1 - System Information Display
├── q2_file_manager.sh      # Question 2 - File and Directory Manager
├── q3_log_analyzer.sh      # Question 3 - Log File Analyzer
├── q4_backup.sh            # Question 4 - Automated Backup Script
├── q5_user_report.sh       # Question 5 - User Account Reporter
├── access.log              # Sample log file used for Question 3
└── README.md               # This file
```

---

## ✅ Prerequisites

Before running any script, make sure you have the following:

- A Linux system — **Kali Linux**, Ubuntu, or Debian recommended
- If on Windows — use **WSL (Windows Subsystem for Linux)** with Kali
- Bash shell (comes pre-installed on all Linux systems)
- `sudo` access for Script 5 (reading system files)
- Basic terminal knowledge (cd, ls, nano)

---


## 📝 Q1 — System Information Display

**File:** `q1_system_info.sh`   
**Difficulty:** Easy

### What it does
Displays a neatly formatted box in the terminal showing key system
information including username, hostname, date and time, OS type,
current directory, home directory, number of users online, and uptime.
Bonus features include disk usage, memory usage, and ANSI color coding.

### Commands used inside the script
| Command | Purpose |
|---------|---------|
| `whoami` | Gets current logged-in username |
| `hostname` | Gets the machine's hostname |
| `date` | Gets current date and time |
| `uname -s` | Gets the operating system name |
| `pwd` | Gets current working directory |
| `$HOME` | Environment variable for home directory |
| `who \| wc -l` | Counts number of users logged in |
| `uptime -p` | Gets system uptime in readable format |
| `df -h /` | Gets disk usage of root partition |
| `free -h` | Gets memory usage |

### How to run
```bash
./q1_system_info.sh
```

### Sample output
```
╔════════════════════════════════════════════════╗
║         SYSTEM INFORMATION DISPLAY             ║
╠════════════════════════════════════════════════╣
║  Username     : kali
║  Hostname     : kali-linux
║  Date & Time  : 2024-02-20 14:30:45
║  OS           : Linux
║  Current Dir  : /home/kali/bash_assignment
║  Home Dir     : /home/kali
║  Users Online : 1
║  Uptime       : up 2 hours, 15 minutes
╠════════════════════════════════════════════════╣
║  Disk Usage   : 8.5G used / 50G total
║  Memory Usage : 1.2G used / 4.0G total
╚════════════════════════════════════════════════╝
```

---

## 📝 Q2 — File and Directory Manager

**File:** `q2_file_manager.sh`  
**Difficulty:** Easy-Medium

### What it does
An interactive menu-driven script that lets you manage files and
directories from the terminal. It uses a `while` loop to keep the menu
running and a `case` statement to handle each user choice. Input
validation is included — for example, it checks if a file exists before
trying to delete it.

### Menu options
| Option | Action | Command used |
|--------|--------|-------------|
| 1 | List files | `ls -lh` |
| 2 | Create directory | `mkdir` |
| 3 | Create file | `touch` |
| 4 | Delete file | `rm` (with confirmation) |
| 5 | Rename file | `mv` |
| 6 | Search for file | `find` |
| 7 | Count files & directories | `find + wc -l` |
| 8 | View file permissions (bonus) | `ls -la` |
| 9 | Copy a file (bonus) | `cp` |
| 10| Exit | `exit` |

### How to run
```bash
./q2_file_manager.sh
```
The menu appears automatically — just type the number and press Enter.

### Testing tips
```bash
# create some test files before running to have something to work with
touch testfile1.txt testfile2.txt
mkdir testfolder
./q2_file_manager.sh
```

---

## 📝 Q3 — Log File Analyzer

**File:** `q3_log_analyzer.sh`   
**Difficulty:** Medium

### What it does
Reads a web server access log file and generates a detailed statistics
report. It counts total entries, finds unique IP addresses, summarizes
HTTP status codes, identifies the most visited page, and lists the top
3 IPs by request count. The bonus features include security threat
detection (IPs with multiple 403 errors) and CSV report export.

### Commands used inside the script
| Command | Purpose |
|---------|---------|
| `wc -l` | Count total number of log entries |
| `awk '{print $1}'` | Extract IP address (column 1) |
| `sort` | Sort output alphabetically or numerically |
| `uniq` | Remove duplicate lines |
| `uniq -c` | Count occurrences of each unique line |
| `sort -rn` | Sort by number in reverse (highest first) |
| `head -3` | Show only top 3 results |
| `grep` | Search for specific status codes |
| `$NF` | awk variable for last column in a line |

### How to run

First create the sample log file:
```bash
cat > access.log << 'EOF'
192.168.1.10 - - [20/Feb/2024:10:30:45] "GET /home" 200
192.168.1.20 - - [20/Feb/2024:10:31:12] "GET /about" 200
192.168.1.10 - - [20/Feb/2024:10:32:05] "GET /contact" 404
192.168.1.30 - - [20/Feb/2024:10:33:22] "POST /login" 200
192.168.1.20 - - [20/Feb/2024:10:34:18] "GET /home" 200
192.168.1.40 - - [20/Feb/2024:10:35:40] "GET /admin" 403
192.168.1.10 - - [20/Feb/2024:10:36:55] "GET /home" 200
EOF
```

Then run the script:
```bash
./q3_log_analyzer.sh access.log
```

### Error handling tests
```bash
# test 1 - no argument
./q3_log_analyzer.sh

# test 2 - file does not exist
./q3_log_analyzer.sh fakefile.log

# test 3 - empty log file
touch empty.log
./q3_log_analyzer.sh empty.log
```

The script auto-generates a CSV file after every run:
```bash
cat log_report.csv

---

## 📝 Q4 — Automated Backup Script

**File:** `q4_backup.sh`  
**Difficulty:** Medium

### What it does
Creates an automated backup of any folder you choose. It asks for the
source directory, destination folder, and backup type. It then creates
either a simple copy or a compressed `.tar.gz` archive with a timestamp
in the filename so backups never overwrite each other. Bonus features
include automatic deletion of old backups (keeps only the last 5) and
a backup history log file.

### Commands used inside the script
| Command | Purpose |
|---------|---------|
| `cp -r` | Recursively copy a folder |
| `tar -czf` | Create compressed .tar.gz archive |
| `mkdir -p` | Create destination folder if it doesn't exist |
| `du -sh` | Get human-readable size of backup |
| `date +%Y%m%d_%H%M%S` | Generate timestamp for filename |
| `date +%s` | Get time in seconds (for duration calculation) |
| `ls -1t` | List files sorted by newest first |

### How to run

First create a test folder to backup:
```bash
mkdir test_project
touch test_project/index.html test_project/style.css test_project/notes.txt
mkdir my_backups
```

Then run:
```bash
./q4_backup.sh
```

Follow the prompts:
```
Enter directory to backup: test_project
Enter backup destination folder: my_backups
Enter choice (1 or 2): 2
```

### Verify backup was created
```bash
ls my_backups/
# backup_20240220_143055.tar.gz

cat backup_history.log
# shows log of all backups made
```

### Test old backup cleanup
```bash
# run script 6 times to trigger the cleanup
for i in {1..6}; do
    echo -e "test_project\nmy_backups\n2" | ./q4_backup.sh
    sleep 2
done


---

## 📝 Q5 — User Account Reporter

**File:** `q5_user_report.sh`  
**Difficulty:** Medium-Hard

### What it does
Generates a detailed security-focused report about all user accounts
on the system. It reads from `/etc/passwd`, `/etc/shadow`, and
`/etc/group` system files to produce statistics, a user details table,
group information, and security alerts. Requires `sudo` for full access
to password information. Bonus feature generates an HTML report file.

### What it reads
| File | Contains |
|------|---------|
| `/etc/passwd` | All user accounts — username, UID, home dir, shell |
| `/etc/shadow` | Password hashes — needs sudo to read |
| `/etc/group` | All groups and their members |

### Commands used inside the script
| Command | Purpose |
|---------|---------|
| `awk -F:` | Parse colon-separated system files |
| `wc -l` | Count total users |
| `who` | Show currently logged in users |
| `lastlog` | Show last login time for each user |
| `printf` | Format output into aligned table columns |

### How to run

With full sudo access (recommended):
```bash
sudo ./q5_user_report.sh
```

Save output to a text file:
```bash
sudo ./q5_user_report.sh > user_report.txt
cat user_report.txt
```

### Check the HTML report
```bash
cat user_report.html


## 🔧 Common Errors and Fixes

| Error Message | Cause | Fix |
|---------------|-------|-----|
| `Permission denied` | Script not executable | `chmod +x scriptname.sh` |
| `bad interpreter: No such file` | Windows line endings | `sed -i 's/\r//' scriptname.sh` |
| `command not found` | Tool not installed | `sudo apt install <toolname> -y` |
| `lastlog: command not found` | Login package missing | `sudo apt install login -y` |
| `/etc/shadow: Permission denied` | Need root access | Run with `sudo` |
| `awk: syntax error` | Paste error in nano | Delete file and paste again carefully |
| Menu loops incorrectly | Bad input | Press `Ctrl + C` to exit and rerun |

---

## 👤 Author

**Name:** Jnanaskanda K  
**Course:** CampusPe Cybersecurity   
**GitHub:** [github.com/jsknda](https://github.com/jsknda)

---

## Running All Scripts

# make everything executable first
chmod +x *.sh

# Q1 - just run it
./q1_system_info.sh

# Q2 - interactive menu
./q2_file_manager.sh

# Q3 - needs a log file as argument
./q3_log_analyzer.sh access.log

# Q4 - interactive prompts
./q4_backup.sh

# Q5 - needs sudo for full output
sudo ./q5_user_report.sh
```

---

*Tested on Kali Linux | CampusPe Cybersecurity*