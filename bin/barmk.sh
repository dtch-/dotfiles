#!/bin/sh
# 
# dtch - (c) wtfpl 2014
# fetch info and print to stdout

clock () {
    date '+%H.%M'
}

volume() {
    amixer get PCM | sed -n 's/^.*\[\([0-9]\+\)%.*$/\1/p' | uniq
}

cpu() {
    LINE=`ps -eo pcpu | grep -vE '^\s*(0.0|%CPU)' | sed -n '1h;$!H;$g;s/\n/ +/gp'`
    bc <<< $LINE
}

ram() {
    read t f <<< `grep -E 'Mem(Total|Free)' /proc/meminfo | awk '{print $2}'`
    bc <<< "scale=2; 100 - $f / $t * 100" | cut -d. -f1
}

#nowplaying() {
#    cur=`mpc current`
#    test "$1" = "scroll" && PARSER='skroll -n20 -d0.5 -r' || PARSER='cat'
#    test -n "$cur" && $PARSER <<< $cur || echo "- stopped -"
#}

music() {
    echo -n $(test -z "$(mpc current)" || mpc current -f "%title%")
}

while :; do
    buf=""
    buf="${buf} MPD: $(music) -"
    buf="${buf} VOL: $(volume)%% -"
    buf="${buf} CLK: $(clock) -"
    buf="${buf} RAM: $(ram)%% -"
    buf="${buf} CPU: $(cpu)%%"

    echo $buf
    sleep 1
done
