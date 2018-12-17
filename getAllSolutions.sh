#!/bin/bash
runs=${1:-1}
for day in {1..25}
do
    echo "##Day $day"
    for puzzle in 1 2 
    do
        echo "###Puzzle $puzzle"
        target="days/$day/puzzles/$puzzle/"
        if [ -d $target ]
        then
            cd $target 2>&1 >/dev/null
            for run in $(seq 1 $runs)
            do
                echo "Run $run of $runs"
                echo '```'
                (time ./getResults.sh) 2>&1
                echo '```'
            done
            cd - 2>&1 >/dev/null
        else
            echo "   Puzzle not yet solved."
        fi
    done
done
