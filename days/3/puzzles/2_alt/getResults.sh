#!/bin/bash
cat input | sed 's/#/region(/' | sed 's/[@:x]/,/g' | sed 's/$/)./' > input.pl
swipl -g "[program], [input], uncontested(R), write(R), halt."
