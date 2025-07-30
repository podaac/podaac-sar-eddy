#/bin/bash
printenv
echo "$PWD"
ls -l

conda run -n sar_eddy_env python src/main.py --config config/inference.yaml
