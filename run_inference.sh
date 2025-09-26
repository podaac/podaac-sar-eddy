#/bin/bash
printenv
echo "$PWD"
ls -l

# filename like S1A_IW_GRDH_1SDV_20190101T142231_20190101T142256_025285_02CBF8_4954.tar.gz
# Download the data/preview files
aws s3 cp s3://$OUTPUT_BUCKET_NAME/sar_eddy/to_process/$FILE_NAME .
tar -xvzf $FILE_NAME .

output_tar=$(./generate_name.sh $FILE_NAME)
echo "$output_tar"

# disable timm_xgb nference for now
# hydra/job_logging=disabled = turn off hydra logging config, see if we get stdout logging
conda run --no-capture-output -n sar_eddy_env python src/main.py mode=inference_only paths.processed_dir=data/processed  #hydra/job_logging=disabled #inference=timm_xgb


#need to name the file appropriately here...
tar -czvf $output_tar -C output .
conda run -n sar_eddy_env aws s3 cp $output_tar s3://$OUTPUT_BUCKET_NAME/sar_eddy/$output_tar --region us-west-2
