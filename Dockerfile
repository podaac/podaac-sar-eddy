from condaforge/miniforge3:25.3.0-3
#from continuumio/miniconda3

run conda create -n sar_eddy_env python=3.10
run conda install -n sar_eddy_env pandas rasterio libgdal geopandas shapely tqdm pyyaml scikit-learn xgboost -c conda-forge -y --quiet
#run conda install -n sar_eddy_env pandas rasterio libgdal "geopandas>1.0.0" shapely tqdm pyyaml -c conda-forge -y --quiet
run conda install -n sar_eddy_env pytorch torchvision -c conda-forge -y --quiet
run conda install -n sar_eddy_env timm -c conda-forge -y --quiet
#run conda install -n sar_eddy_env pytorch torchvision -c conda-forge -y --quiet


copy sar_eddy_detector_demo/ .
copy run.sh .

CMD ["sh" , "run.sh"]
