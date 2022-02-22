# Testing the vagrant box

## Usage

### Upload the data
First upload the data into the minio. In the folder `data/` you can find 4 testsets.

1. Navigate to `http://armadillo-storage.local`
2. Login with root user: xxxxxx and root password: xxxxxx
3. Create a bucket called `shared-local`
4. Create a folder called `1_0_core_1_0`
5. Upload the parquet files from `data/core` into `1_0_core_1_0`
6. Create a folder called `1_0_outcome_1_0`
7. Upload the parquet files from `data/outcome` into `1_0_outcome_1_0`

### Data analysis
To analyse the data you need an r-environment. You can use native R or RStudio. In this description we are using RStudio.

1. Start an RStudio
2. Copy the `test-local.R` file to the RStudio
3. Run the commands
4. Make sure you do not see any error messages