#/bin/bash
printenv
echo "$PWD"
ls -l

conda run -n sar_eddy_env python src/main.py --config config/inference.yaml

tar -czvf outputs.tar.gz -C output .
conda run -n sar_eddy_env aws s3 cp outputs.tar.gz s3://$OUTPUT_BUCKET_NAME/sar_eddy/$SAR_TASK_ID_outputs.tar.gz
