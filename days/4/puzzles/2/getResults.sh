#!/bin/bash
FILE=input
cat $FILE | sort | awk -f program.awk
