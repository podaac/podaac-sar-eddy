# PODAAC SAR Eddy Detection

A wrapper for JPL SLICE's machine learning-powered system for detecting ocean eddies from Synthetic Aperture Radar (SAR) satellite imagery. This tool provides an end-to-end pipeline for downloading SAR data, preprocessing, and detecting mesoscale ocean eddies using deep learning models.

## Overview

Ocean eddies are circular currents of water that play crucial roles in ocean dynamics, heat transport, and marine ecosystems. This project uses SAR imagery from Sentinel-1 satellites to automatically detect and locate these features across ocean surfaces.

### Key Features

- **End-to-End Pipeline**: Automated workflow from data download to visualization
- **Multiple Detection Models**: SimCLR and TIMM+XGBoost algorithms
- **HyP3 Integration**: Direct integration with ASF's HyP3 service for SAR data processing
- **Configurable Processing**: Flexible parameter adjustment via YAML configuration files
- **Docker Support**: Containerized deployment for consistent execution environments

## Prerequisites

- **NASA Earthdata Account**: Required for downloading SAR data through HyP3
- **Docker** (recommended) or **Conda/Python 3.10+** for local installation
- **AWS CLI** (for cloud deployment scenarios)

## Quick Start

### Option 1: Docker (Recommended)

1. **Build the container**:
   ```bash
   docker build -t podaac/sar-eddy .
   ```

2. **Run the detection pipeline**:
   ```bash
   # Increase shared memory for PyTorch operations
   docker run --shm-size="2g" podaac/sar-eddy
   ```

### Option 2: Local Installation

1. **Create conda environment**:
   ```bash
   conda create --name sar_eddy_env python=3.10 pandas rasterio libgdal geopandas shapely tqdm pyyaml pytorch torchvision timm scikit-learn xgboost hydra-core hyp3_sdk -c conda-forge
   conda activate sar_eddy_env
   ```

2. **Run the complete workflow**:
   ```bash
   cd sar_eddy_detector_demo
   python src/main.py
   ```

3. **Run detection only** (on existing processed data):
   ```bash
   python src/main.py mode=inference_only paths.processed_dir=data/
   ```

## Usage Examples

For insutrcuctions on running the model itsef, please view the JPL SLICE repository. This wraps that model in a callable docker infrastructure to be run in Earthdata Cloud.

The docker container expects the following environment variables:

| Variable | Description | 
|------|-------------|
| `SEARCH_RESULTS_KEY` | The key (name of the file) in OUTPUT_BUCKET_NAME that provides the yaml contents of granules to process|
| `$OUTPUT_BUCKET_NAME` | The bucket that contains SEARCH_RESUTLS_KEY and will also store the output zip archive of the process |
| `SAR_TASK_ID` | Generally provided by airflow, this is a unique ID for the run to store outputs |
| `SSM_EDL_USERNAME` | The SSM Parameter containing the EDL Username for hyp3 job submissions |
| `SSM_EDL_PASSWORD` | The SSM Parameter containing the EDL Password for hyp3 job submissions |


## Project Structure

```
├── README.md                    # This file
├── Dockerfile                   # Container build instructions
├── run.sh                      # Docker entry point script
└── sar_eddy_detector_demo/     # Main application directory - see https://github.com/jpl-slice/sar_eddy_detector_demo/
```

## Outputs

The detection pipeline generates:

- **CSV Files**: Eddy locations with bounding boxes, confidence scores, and coordinates
- **Visualizations**: SAR imagery overlaid with detected eddy boundaries
- **Processing Logs**: Detailed execution logs for debugging and analysis

Example output structure:
```
output/
├── positive_eddy_identifications.csv
├── previews_0.999/
│   └── *.png                  # Visualization images
└── positive_detection_tiles_0.5/
    └── */                     # Individual detection tiles
```

These outputs are bundled in a zip file and uploaded to s3://$OUTPUT_BUCKET_NAME/sar_eddy/${SAR_TASK_ID}_outputs.tar.gz

## Configuration

The system uses [Hydra](https://hydra.cc/) for flexible configuration management. Key configuration files:

- `config/config.yaml`: Main workflow settings and paths
- `config/hyp3/`: HyP3 download parameters and granule lists
- `config/preprocessing/`: Land masking and normalization settings  
- `config/inference/`: Detection model parameters

See [`sar_eddy_detector_demo/README.md`](sar_eddy_detector_demo/README.md) for comprehensive configuration documentation.

## Workflow Modes

| Mode | Description | Use Case |
|------|-------------|----------|
| `full` | Download → Preprocess → Detect | Complete end-to-end processing |
| `hyp3_only` | Download → Preprocess only | Data preparation and validation |
| `inference_only` | Detection only | Model testing on existing data |

## Documentation

For detailed information, see:
- **[Main Documentation](https://github.com/jpl-slice/sar_eddy_detector_demo/README.md)**: Comprehensive usage guide

## Support

This project is part of NASA's Physical Oceanography Distributed Active Archive Center (PO.DAAC) initiatives for advancing ocean remote sensing capabilities.
