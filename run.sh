#/bin/bash

printenv
echo "$PWD"
conda run -n sar_eddy_env python src/main.py --config config/inference.yaml
