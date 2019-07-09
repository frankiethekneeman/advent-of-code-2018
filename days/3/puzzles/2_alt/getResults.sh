#!/bin/bash
cat input | sed 's/#/region(/' | sed 's/[@:x]/,/g' | sed 's/$/)./' > facts.pl
swipl -g "[facts], [rules], uncontested(ID, X, Y, Width, Height), write(ID), halt."
