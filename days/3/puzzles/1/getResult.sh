#!/bin/bash
cat input | sed 's/#/region(/' | sed 's/[@:x]/,/g' | sed 's/$/)./' > input.pl
swipl -g "[program], [input], main(C), write(C), halt."
