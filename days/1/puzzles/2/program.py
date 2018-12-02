#import antigravity
import fileinput

seenFrequencies = set()
currentFrequency = 0
found = False
stdin = fileinput.input()
changes = [int(line) for line in stdin if not line == '']

while not found:
    for delta in changes:
        if currentFrequency in seenFrequencies:
            found = True
            break #essential!
        seenFrequencies.add(currentFrequency)
        currentFrequency += delta

print currentFrequency
