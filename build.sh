#!/bin/bash

mkdir bin && cd bin &&
mkdir gui && cd gui &&
qmake ../../src/gui && make && make clean && rm Makefile
