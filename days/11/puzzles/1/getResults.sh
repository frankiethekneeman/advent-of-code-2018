#!/bin/bash
SERIAL_NUMBER=6303

cellScore() {
    X=$1
    Y=$2
    RACK_ID=$(($X + 10))
    BIG=$(( ( ( $RACK_ID ) * $Y + $SERIAL_NUMBER ) * ( $RACK_ID ) ))
    echo $(( ( ( $BIG ) % 1000 - ( $BIG ) % 100 ) / 100 - 5 ))
}

regionScore() {
    X=$1
    Y=$2
    echo $(( 0 $(for x in $(seq $X $(expr $X + 2))
        do
            for y in $(seq $Y $(expr $Y + 2))
            do 
                echo + $(cellScore $x $y)
            done
        done)))
}

for x in {1..298}
do
    for y in {1..298}
    do
        echo -n "$x $y "
        regionScore $x $y
    done
done | sort -rnk 3 | head -n1 | cut -d' ' -f1,2
