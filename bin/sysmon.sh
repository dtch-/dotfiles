#!/bin/sh
#
# dtch - (c) wtfpl 2014
# fetch system info and print it every second

# get date and print as 'DAY MONTH HOUR.MINUTE'
# if you don't know the year, you're an idiot
dt() {
    date +'%a %b %H.%M'
}

# get volume from amixer
vol() {
    amixer get PCM | sed -n 's/^.*\[\([0-9]\+\)%.*$/\1/p' | uniq
}

# get song info from mpc
music() {
   mpc current
}

# get memory 
mem() { 
    read t f <<< `grep -E 'Mem(Total|Free)' /proc/meminfo | awk '{print $2}'`
    bc <<< "scale=2; 100 - $f / $t * 100" | cut -d. -f1
}

# get cpu
cpu() {
    LINE=`ps -eo pcpu | grep -vE '^\s*(0.0|%CPU)' | sed -n '1h;$!H;$g;s/\n/ +/gp'`
    bc <<< $LINE
}

output() {
    echo -e "
    clock\t $(dt)
    music\t $(music)
    volume\t $(vol)%
    mem\t\t $(mem)%
    cpu\t\t $(cpu)%"
}

while :; do
    output
    sleep 1
    #clear
done
