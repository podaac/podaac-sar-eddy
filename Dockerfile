from condaforge/miniforge3:25.3.0-3
#from continuumio/miniconda3

run conda create --name sar_eddy_env python=3.10 pandas rasterio libgdal geopandas shapely tqdm pyyaml pytorch torchvision timm scikit-learn xgboost hydra-core hyp3_sdk -c conda-forge
run conda install -n sar_eddy_env awscli  -c conda-forge -y --quiet

run apt-get update; apt-get install --no-install-recommends --yes jq; python -m pip install awscli 


WORKDIR /app

run apt-get install -y vim

copy sar_eddy_detector_demo/ . 
copy run.sh run_hype.sh run_inference.sh create_archive.sh .
run chmod +x create_archive.sh

CMD ["sh" , "run_hype.sh"]
