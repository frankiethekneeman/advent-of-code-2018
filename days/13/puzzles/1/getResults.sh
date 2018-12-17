#!/bin/bash
g++ -std=c++11 -fpermissive -o program.exe program.cpp >/dev/null 2>&1
./program.exe < input
