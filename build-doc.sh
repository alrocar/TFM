#!/bin/bash

pip install -r requirements.txt
cd docs
make clean && make html && make latex && make latexpdf
