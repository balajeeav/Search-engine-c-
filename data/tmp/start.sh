#!/bin/bash

R --slave --vanilla --args "$1" $2 < $3 > $4
