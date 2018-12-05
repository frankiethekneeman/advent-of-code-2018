match($0, /Guard #([0-9]+) begins/, groups) {
    currentGaurd = groups[1];
}

match($0, /([0-9]+)] falls asleep/, groups) {
    sleepStarted = groups[1];
}

match($0, /([0-9]+)] wakes up/, groups) {
    sleepEnded = groups[1];
    for (i=sleepStarted; i < sleepEnded; i++) {
        sleepTimes[currentGaurd][i]++;
    }
}
END {
    for (gaurd in sleepTimes) {
        sleepiness=0;
        for (time in sleepTimes[gaurd]) {
            sleepiness += sleepTimes[gaurd][time];
        }
        if (sleepiness > sleepiest) {
            sleepiest = sleepiness;
            sleepiestGaurd = gaurd;
        }
    }
    for (minute in sleepTimes[sleepiestGaurd]) {
        slept = sleepTimes[sleepiestGaurd][minute]
        if (slept > mostSlept) {
            mostSlept = slept;
            sleepiestMinute = minute;
        }
    }
    print sleepiestGaurd * sleepiestMinute;
}
