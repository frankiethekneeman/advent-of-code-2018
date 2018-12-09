#!/bin/bash
ghc -O program 2>&1 >/dev/null
./program < input
