#/bin/bash
printenv
echo "$PWD"
ls -l


# Setup netrc file
export edl_username=`aws ssm get-parameter --with-decryption --name $SSM_EDL_USERNAME | jq .Parameter.Value --raw-output`
export edl_password=`aws ssm get-parameter --with-decryption --name $SSM_EDL_PASSWORD | jq .Parameter.Value --raw-output`

cat > ~/.netrc <<EOF
machine urs.earthdata.nasa.gov
  login $edl_username
  password $edl_password
EOF

#get the results.txt file
conda run -n sar_eddy_env aws s3 cp s3://$OUTPUT_BUCKET_NAME/$SEARCH_RESULTS_KEY config/hyp3/granules_batch.yaml
cat config/hyp3/granules_batch.yaml


# disable timm_xgb nference for now
# hydra/job_logging=disabled = turn off hydra logging config, see if we get stdout logging
conda run --no-capture-output -n sar_eddy_env python src/main.py hyp3=granules_batch #hydra/job_logging=disabled #inference=timm_xgb

tar -czvf outputs.tar.gz -C output .
conda run -n sar_eddy_env aws s3 cp outputs.tar.gz s3://$OUTPUT_BUCKET_NAME/sar_eddy/${SAR_TASK_ID}_outputs.tar.gz --region us-west-2
