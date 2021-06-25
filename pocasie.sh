#!/bin/bash

FULL_TEMP=$(
	curl wttr.in/$1 2>&- | # get the weather report
	sed 7q |               # first seven lines
	grep °C |              # find the temperature
	sed s/\\x1b\\\[\[0-9\\\;\]*m//g |  # remove escape sequences
	sed s/\\s*°C.*$// |    # remove the °C mark
	sed s/\[+\\-\]\[^0-9]//g |         #remove each + or - that isn't followed by a number
	sed s/^\[^0123456789+\\-\]*// | # extract the number
	sed s/^\\\(\[^+\\-\]\\\)/+\1/   # add a + at the beginning
)

echo full\ temperature\ :\ $FULL_TEMP

TEMP=$(echo $FULL_TEMP | sed s/\(.*\$// )

echo converted\ temperature\ :\ $TEMP

FORECAST=$(
	[ $(echo "0$TEMP>=25" | bc) == 1 ] && printf horúco;
	[ $(echo "0$TEMP<=25" | bc) == 1 ] && [ $(echo "0$TEMP>15" | bc) == 1 ] && printf príjemne;
	[ $(echo "0$TEMP<=15" | bc) == 1 ] && [ $(echo "0$TEMP>0" | bc) == 1 ] && printf studeno;
	[ $(echo "0$TEMP<=0 " | bc) == 1 ] && [ $(echo "0$TEMP>-273.15 " | bc) == 1 ] && printf mrazivo;
	[ $(echo "0$TEMP<=-273.15 " | bc) == 1 ] && printf nereálne\ marzivo;
)


convert extremne.png -pointsize 100 -draw "text 80,285 '$FORECAST'" -size x100  xc:\#ffffff -append -fill black -pointsize 30 -draw "text 96, 886 'btw teplota je $FULL_TEMP °C'"  /tmp/predpoved.png

pqiv /tmp/predpoved.png
