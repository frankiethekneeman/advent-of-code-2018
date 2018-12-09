for day in {1..25}
do
    for puzzle in 1 2 
    do
        echo "Day $day, Puzzle #$puzzle"
        target="days/$day/puzzles/$puzzle/"
        if [ -d $target ]
        then
            cd $target
            echo -n "-> "
            ./getResults.sh
            cd -
        else
            echo "-> Puzzle not yet solved."
        fi
    done
done
