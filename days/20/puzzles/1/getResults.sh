#!/bin/bash
erl -compile program 2>&1 >/dev/null
erl -noshell -s program main -s init stop < input
