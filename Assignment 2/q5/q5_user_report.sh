#!/bin/bash

echo ""
echo "======================================"
echo "         USER ACCOUNT REPORT         "
echo "======================================"
echo ""

# /etc/passwd format: username:x:uid:gid:comment:home:shell

total_users=$(wc -l < /etc/passwd)

system_users=$(awk -F: '$3 < 1000 {count++} END {print count+0}' /etc/passwd)

regular_users=$(awk -F: '$3 >= 1000 && $3 < 65534 {count++} END {print count+0}' /etc/passwd)

logged_in=$(who | awk '{print $1}' | sort -u | wc -l)

echo "=== USER STATISTICS ==="
echo "Total Users              : $total_users"
echo "System Users (UID < 1000): $system_users"
echo "Regular Users (UID>=1000): $regular_users"
echo "Currently Logged In      : $logged_in"
echo ""


echo "Currently logged in users:"
who | awk '{print "   - " $1 " (logged in from terminal " $2 ")"}' 2>/dev/null
if [ $(who | wc -l) -eq 0 ]; then
    echo "   (no one currently logged in or unable to detect)"
fi
echo ""

echo "=== REGULAR USER DETAILS ==="
printf "%-15s %-6s %-25s %-15s\n" "Username" "UID" "Home Directory" "Shell"
echo "-------- --- -------------- -----"

awk -F: '$3 >= 1000 && $3 < 65534 {printf "%-15s %-6s %-25s %-15s\n", $1, $3, $6, $7}' /etc/passwd

echo ""

echo "=== LAST LOGIN INFO ==="
awk -F: '$3 >= 1000 && $3 < 65534 {print $1}' /etc/passwd | while read username; do
    last_login=$(lastlog -u "$username" 2>/dev/null | tail -1 | awk '{if ($2 == "**Never") print "Never logged in"; else print $4,$5,$6,$7,$8,$9}')
    echo "   $username : $last_login"
done

echo ""

echo "=== GROUP INFORMATION ==="
echo "Groups and their member count:"
# /etc/group format: groupname:x:gid:members
awk -F: '{
    if ($4 == "") {
        members = 0
    } else {
        n = split($4, arr, ",")
        members = n
    }
    printf "   %-20s (GID: %-5s) - %d member(s)\n", $1, $3, members
}' /etc/group | head -20

echo "   ... (showing first 20 groups)"

echo ""

echo "=== SECURITY ALERTS ==="

echo "Users with root privileges (UID 0):"
root_users=$(awk -F: '$3 == 0 {print $1}' /etc/passwd)
if [ -z "$root_users" ]; then
    echo "   (none found - that is strange)"
else
    echo "$root_users" | while read u; do
        echo "   - $u"
    done
fi

echo ""
echo "Users without passwords (requires sudo):"
if [ -r /etc/shadow ]; then
    no_pass=$(awk -F: '($2 == "" || $2 == "!") && $1 != "root" {print $1}' /etc/shadow)
    if [ -z "$no_pass" ]; then
        echo "   All users have passwords set. Good!"
    else
        echo "$no_pass" | while read u; do
            echo "   [!!] $u has no password set!"
        done
    fi
else
    echo "   Cannot read /etc/shadow - try running with sudo"
fi

echo ""

echo "Users who never logged in:"
awk -F: '$3 >= 1000 && $3 < 65534 {print $1}' /etc/passwd | while read username; do
    never=$(lastlog -u "$username" 2>/dev/null | grep "Never logged in")
    if [ ! -z "$never" ]; then
        echo "   - $username"
    fi
done

echo ""

HTML_FILE="user_report.html"
echo "<html><head><title>User Report</title></head><body>" > "$HTML_FILE"
echo "<h1>User Account Report - $(date)</h1>" >> "$HTML_FILE"
echo "<h2>Total Users: $total_users | System: $system_users | Regular: $regular_users</h2>" >> "$HTML_FILE"
echo "<h3>Regular Users</h3><pre>" >> "$HTML_FILE"
awk -F: '$3 >= 1000 && $3 < 65534 {print $1, $3, $6, $7}' /etc/passwd >> "$HTML_FILE"
echo "</pre></body></html>" >> "$HTML_FILE"
echo "[+] HTML report saved to: $HTML_FILE"

echo "======================================"
echo ""
