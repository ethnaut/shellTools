#!/bin/bash
# File: utilities.sh
# Description: Various utility functions for string manipulation, internet, and network operations.
# Inspired by features from Perl, Python, Lua, and Ruby.

####################
# String Functions #
####################

# 1. Remove newline at the end (Perl chomp)
chomp() {
    local str="$1"
    str="${str%$'\n'}"
    echo "$str"
}

# 2. Remove trailing whitespaces (Python rstrip)
rstrip() {
    local str="$1"
    str="${str%%[[:space:]]*}"
    echo "$str"
}

# 3. Convert to uppercase (Lua string.upper)
to_upper() {
    local str="$1"
    echo "${str^^}"
}

# 4. Convert to lowercase (Lua string.lower)
to_lower() {
    local str="$1"
    echo "${str,,}"
}

# 5. Remove leading and trailing whitespaces (Ruby strip)
strip() {
    local str="$1"
    str="$(echo "$str" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
    echo "$str"
}

# 6. Split string into an array (Python split)
split() {
    local str="$1"
    local delimiter="$2"
    IFS="$delimiter" read -ra arr <<< "$str"
    echo "${arr[@]}"
}

# 7. Join array elements into a string (Perl join)
join() {
    local delimiter="$1"
    shift
    local arr=("$@")
    local joined=$(IFS="$delimiter"; echo "${arr[*]}")
    echo "$joined"
}

# 8. Global substitution (Ruby gsub)
gsub() {
    local str="$1"
    local search="$2"
    local replace="$3"
    echo "${str//$search/$replace}"
}

# 9. Reverse string (Perl reverse)
reverse() {
    local str="$1"
    echo "$str" | rev
}

# 10. String length (Python len)
strlen() {
    local str="$1"
    echo "${#str}"
}

# 11. Check if a string contains another string (Perl-like contains)
contains() {
    local haystack="$1"
    local needle="$2"
    if [[ "$haystack" == *"$needle"* ]]; then
        return 0
    else
        return 1
    fi
}

# 12. Replace first occurrence (Python replace)
replace_first() {
    local str="$1"
    local search="$2"
    local replace="$3"
    echo "${str/$search/$replace}"
}

# 13. Count occurrences of a substring (Ruby count)
count_substring() {
    local str="$1"
    local substring="$2"
    echo "$str" | grep -o "$substring" | wc -l
}

# 14. Pad a string to the right (Perl sprintf)
pad_right() {
    local str="$1"
    local pad_char="$2"
    local length="$3"
    printf "%-${length}s" "$str" | sed "s/ /$pad_char/g"
}

# 15. Pad a string to the left (Perl sprintf)
pad_left() {
    local str="$1"
    local pad_char="$2"
    local length="$3"
    printf "%${length}s" "$str" | sed "s/ /$pad_char/g"
}

# 16. Capitalize first letter (Ruby capitalize)
capitalize() {
    local str="$1"
    echo "${str^}"
}

# 17. Extract substring (Python slice)
substring() {
    local str="$1"
    local start="$2"
    local length="$3"
    echo "${str:$start:$length}"
}

# 18. Remove all digits from a string
remove_digits() {
    local str="$1"
    echo "$str" | tr -d '0-9'
}

# 19. Remove all non-digit characters from a string
keep_digits() {
    local str="$1"
    echo "$str" | tr -cd '0-9'
}

# 20. Check if a string is a number
is_number() {
    local str="$1"
    if [[ "$str" =~ ^[0-9]+$ ]]; then
        return 0
    else
        return 1
    fi
}

##########################
# Internet/Network Tools #
##########################

# 21. Ping a host and return success or failure
ping_host() {
    local host="$1"
    ping -c 1 "$host" > /dev/null 2>&1
    if [[ $? -eq 0 ]]; then
        echo "Host is reachable"
    else
        echo "Host is unreachable"
    fi
}

# 22. Get public IP address
get_public_ip() {
    curl -s ifconfig.me
}

# 23. Check if a port is open on a host
check_port() {
    local host="$1"
    local port="$2"
    nc -z "$host" "$port" && echo "Port $port on $host is open" || echo "Port $port on $host is closed"
}

# 24. Download a file using wget
download_file() {
    local url="$1"
    local destination="$2"
    wget -O "$destination" "$url"
}

# 25. Download a file using curl
download_file_curl() {
    local url="$1"
    local destination="$2"
    curl -o "$destination" "$url"
}

# 26. Check internet connectivity
check_internet() {
    ping -c 1 8.8.8.8 > /dev/null 2>&1
    if [[ $? -eq 0 ]]; then
        echo "Internet connection is active"
    else
        echo "No internet connection"
    fi
}

# 27. Resolve DNS for a domain
resolve_dns() {
    local domain="$1"
    nslookup "$domain"
}

# 28. Get MAC address of a network interface
get_mac_address() {
    local interface="$1"
    cat /sys/class/net/"$interface"/address
}

# 29. Get IP address of a network interface
get_ip_address() {
    local interface="$1"
    ip addr show "$interface" | grep "inet\b" | awk '{print $2}' | cut -d/ -f1
}

# 30. Start a simple HTTP server (Python-based)
start_http_server() {
    local port="$1"
    python3 -m http.server "$port"
}

# 31. Fetch HTTP headers for a URL
fetch_http_headers() {
    local url="$1"
    curl -I "$url"
}

# 32. Check if a website is online
check_website_online() {
    local url="$1"
    curl -Is "$url" | head -n 1 | grep "200 OK" > /dev/null
    if [[ $? -eq 0 ]]; then
        echo "Website is online"
    else
        echo "Website is offline or unavailable"
    fi
}

# 33. Get WHOIS information for a domain
whois_domain() {
    local domain="$1"
    whois "$domain"
}

# 34. Scan for open ports on a host (requires nmap)
scan_open_ports() {
    local host="$1"
    nmap -F "$host"
}

# 35. Get network statistics
network_stats() {
    netstat -i
}

# 36. Get active network connections
active_connections() {
    netstat -tn
}

# 37. List network interfaces
list_interfaces() {
    ip link show
}

# 38. Test DNS resolution for a domain
test_dns_resolution() {
    local domain="$1"
    dig "$domain" +short
}

# 39. Speed test for internet connection (requires speedtest-cli)
internet_speed_test() {
    speedtest-cli
}

##########################
# File and System Tools #
##########################

# 40. Create a backup of a file
backup_file() {
    local file="$1"
    cp "$file" "$file.bak"
}

# 41. Monitor a file in real-time (like tail -f)
monitor_file() {
    local file="$1"
    tail -f "$file"
}

# 42. Count lines in a file
count_lines() {
    local file="$1"
    wc -l < "$file"
}

# 43. Check disk usage in human-readable format
check_disk_usage() {
    df -h
}

# 44. Check memory usage
check_memory_usage() {
    free -h
}

# 45. Get system uptime
get_uptime() {
    uptime
}

# 46. Check system load averages
check_load_average() {
    uptime | awk -F'load average:' '{ print $2 }'
}

# 47. List files in a directory with details
list_files() {
    local dir="$1"
    ls -lh "$dir"
}

# 48. Find files by name in a directory
find_files_by_name() {
    local dir="$1"
    local name="$2"
    find "$dir" -name "$name"
}

# 49. Search for a string in a file
search_in_file
