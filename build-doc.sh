#!/bin/bash

pip install -r requirements.txt
cd doc
make clean && make html && make latex
