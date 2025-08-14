#/bin/bash
printenv
echo "$PWD"
ls -l


#run intfernce only
conda run -n sar_eddy_env python src/main.py mode=inference_only paths.processed_dir=data/

tar -czvf outputs.tar.gz -C output .
conda run -n sar_eddy_env aws s3 cp outputs.tar.gz s3://$OUTPUT_BUCKET_NAME/sar_eddy/${SAR_TASK_ID}_outputs.tar.gz --region us-west-2
