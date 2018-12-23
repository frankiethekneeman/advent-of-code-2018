#!/bin/bash
kotlinc program.kt -include-runtime -d program.jar
java -jar program.jar < input
