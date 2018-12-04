#!/bin/bash
cat input | sed 's/#/region(/' | sed 's/[@:x]/,/g' | sed 's/$/)./' > input.pl
swipl -g "[program], [input], lonely(R), write(R), halt."
