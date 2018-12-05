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
        for (minute in sleepTimes[gaurd]) {
            slept = sleepTimes[gaurd][minute];
            if (slept > sleepiest) {
                sleepiest = slept;
                sleepiestGaurd = gaurd;
                sleepiestMinute = minute;
            }
        }
    }
    print sleepiestGaurd * sleepiestMinute;
}
