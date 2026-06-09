#!/usr/bin/env bash
# Troubleshooting script for "Tokyo: can't serve web file"
# Goal: make curl 127.0.0.1:80 return "hello sadserver"

set -euo pipefail

PASS="\e[32m[PASS]\e[0m"
FAIL="\e[31m[FAIL]\e[0m"
INFO="\e[34m[INFO]\e[0m"
FIX="\e[33m[FIX]\e[0m"

echo -e "\n=== Tokyo Apache Troubleshooting ==="

# 1. Check if the index file exists and has correct content
echo -e "\n${INFO} Checking /var/www/html/index.html..."
if [ -f /var/www/html/index.html ]; then
    content=$(sudo cat /var/www/html/index.html)
    echo -e "${PASS} File exists. Content: '${content}'"
    if [ "$content" != "hello sadserver" ]; then
        echo -e "${FAIL} Content is wrong. Expected 'hello sadserver'."
        echo "hello sadserver" | sudo tee /var/www/html/index.html
        echo -e "${FIX} Content corrected."
    fi
else
    echo -e "${FAIL} File not found. Creating it..."
    sudo mkdir -p /var/www/html
    echo "hello sadserver" | sudo tee /var/www/html/index.html
    echo -e "${FIX} File created."
fi

# 2. Check file permissions
echo -e "\n${INFO} Checking file permissions..."
perms=$(stat -c "%a %U %G" /var/www/html/index.html 2>/dev/null || stat -f "%p %u %g" /var/www/html/index.html)
echo -e "${INFO} Permissions: ${perms}"
if ! [ -r /var/www/html/index.html ]; then
    echo -e "${FAIL} File is not world-readable. Fixing..."
    sudo chmod 644 /var/www/html/index.html
    echo -e "${FIX} Permissions set to 644."
else
    echo -e "${PASS} File is readable."
fi

# 3. Check which web server is installed
echo -e "\n${INFO} Detecting web server..."
if command -v apache2 &>/dev/null || command -v httpd &>/dev/null; then
    echo -e "${PASS} Apache found."
    APACHE_SVC="apache2"
    command -v httpd &>/dev/null && APACHE_SVC="httpd"
else
    echo -e "${FAIL} Apache not found in PATH."
fi

# 4. Check if Apache is running
echo -e "\n${INFO} Checking Apache service status..."
if sudo systemctl is-active --quiet "${APACHE_SVC:-apache2}" 2>/dev/null; then
    echo -e "${PASS} Apache is running."
else
    echo -e "${FAIL} Apache is not running. Starting it..."
    sudo systemctl start "${APACHE_SVC:-apache2}"
    echo -e "${FIX} Apache started."
fi

# 5. Check if Apache is enabled at boot
echo -e "\n${INFO} Checking if Apache is enabled on boot..."
if sudo systemctl is-enabled --quiet "${APACHE_SVC:-apache2}" 2>/dev/null; then
    echo -e "${PASS} Apache is enabled."
else
    echo -e "${FAIL} Apache is disabled at boot. Enabling..."
    sudo systemctl enable "${APACHE_SVC:-apache2}"
    echo -e "${FIX} Apache enabled."
fi

# 6. Check what's listening on port 80
echo -e "\n${INFO} Checking what is listening on port 80..."
if sudo ss -tlnp sport = :80 2>/dev/null | grep -q ':80'; then
    listener=$(sudo ss -tlnp sport = :80 | grep ':80')
    echo -e "${PASS} Something is listening on port 80:"
    echo "  ${listener}"
else
    echo -e "${FAIL} Nothing is listening on port 80."
    echo -e "${INFO} Checking Apache config for Listen directive..."
    grep -r "^Listen" /etc/apache2/ /etc/httpd/ 2>/dev/null || true
    echo -e "${FIX} Try restarting Apache: sudo systemctl restart ${APACHE_SVC:-apache2}"
    sudo systemctl restart "${APACHE_SVC:-apache2}" 2>/dev/null || true
fi

# 7. Check firewall (iptables)
echo -e "\n${INFO} Checking iptables rules for port 80..."
if sudo iptables -L INPUT -n 2>/dev/null | grep -qE "DROP|REJECT"; then
    echo -e "${FAIL} Potentially blocking rules found in INPUT chain:"
    sudo iptables -L INPUT -n --line-numbers | grep -E "DROP|REJECT|80" || true
    echo -e "${INFO} If port 80 is blocked, run:"
    echo "  sudo iptables -I INPUT -p tcp --dport 80 -j ACCEPT"
else
    echo -e "${PASS} No obvious DROP/REJECT rules in INPUT chain."
fi

# 8. Check Apache error logs for clues
echo -e "\n${INFO} Last 10 lines of Apache error log..."
for logpath in /var/log/apache2/error.log /var/log/httpd/error_log; do
    if [ -f "$logpath" ]; then
        sudo tail -10 "$logpath"
        break
    fi
done

# 9. Final test
echo -e "\n=== Final Test ==="
result=$(curl -s --max-time 5 127.0.0.1:80 || true)
if [ "$result" = "hello sadserver" ]; then
    echo -e "${PASS} SUCCESS: curl 127.0.0.1:80 returned 'hello sadserver'"
else
    echo -e "${FAIL} FAILED: curl returned: '${result}'"
    echo -e "${INFO} Manual steps to try:"
    echo "  1. sudo systemctl status apache2"
    echo "  2. sudo apache2ctl configtest"
    echo "  3. sudo iptables -I INPUT -p tcp --dport 80 -j ACCEPT"
    echo "  4. sudo systemctl restart apache2"
fi
