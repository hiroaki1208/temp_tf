# Google Drive to BigQuery External Table

This Terraform configuration creates a BigQuery external table that connects to a Google Drive spreadsheet.

## Project Structure

```
.
├── main.tf                    # Root Terraform configuration
├── variables.tf               # Root variable definitions
├── outputs.tf                 # Root output values
├── terraform.tfvars.example   # Configuration template
├── README.md                  # This file
├── .gitignore                 # Git ignore rules
└── external_tables/           # External tables module
    ├── main.tf                # Module implementation
    ├── variables.tf           # Module variables
    ├── outputs.tf             # Module outputs
    └── terraform.tfvars.example # Module configuration example
```

## Prerequisites

1. Google Cloud Project with BigQuery API enabled
2. Google Drive spreadsheet that you want to connect to BigQuery
3. Terraform installed on your machine
4. Google Cloud SDK (gcloud) installed and authenticated

## Setup Instructions

### 1. Prepare Google Drive Spreadsheet

1. Make sure your Google Drive spreadsheet is accessible
2. Note the spreadsheet ID from the URL: `https://docs.google.com/spreadsheets/d/{SPREADSHEET_ID}`
3. Ensure the spreadsheet has proper sharing permissions

### 2. Configure Terraform

1. Copy the example configuration file:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

2. Edit `terraform.tfvars` with your actual values:
   - `project_id`: Your GCP project ID
   - `dataset_owner_email`: Your email address
   - `google_drive_spreadsheet_uri`: Full URL to your Google Drive spreadsheet

### 3. Authentication

Authenticate with Google Cloud:
```bash
gcloud auth login
gcloud auth application-default login
gcloud config set project YOUR_PROJECT_ID
```

### 4. Deploy Infrastructure

1. Initialize Terraform:
   ```bash
   terraform init
   ```

2. Plan the deployment:
   ```bash
   terraform plan
   ```

3. Apply the changes:
   ```bash
   terraform apply
   ```

## Configuration Options

### Required Variables
- `project_id`: GCP project ID
- `dataset_owner_email`: Email of the dataset owner
- `google_drive_spreadsheet_uri`: URI of the Google Drive spreadsheet

### Optional Variables
- `dataset_id`: BigQuery dataset name (default: "google_drive_external")
- `table_id`: BigQuery table name (default: "spreadsheet_sheet_a")
- `sheet_range`: Sheet range to import (default: "Sheet A")
- `skip_leading_rows`: Number of header rows to skip (default: 1)
- `autodetect_schema`: Whether to auto-detect schema (default: true)

## Example Usage

After deployment, you can query your external table:

```sql
SELECT * FROM `your-project-id.google_drive_external.spreadsheet_sheet_a`
LIMIT 10;
```

## Important Notes

### Permissions
- The spreadsheet must be shared with appropriate permissions
- For private spreadsheets, you may need to share with the BigQuery service account
- The BigQuery service account email format: `bqcx-{PROJECT_NUMBER}-{RANDOM_ID}@gcp-sa-bigquery-condel.iam.gserviceaccount.com`

### Schema Considerations
- Auto-detection works well for most spreadsheets
- For complex data types, consider defining the schema manually
- Column names are derived from the first row (if skip_leading_rows = 1)

### Limitations
- External tables have some limitations compared to native BigQuery tables
- Data in Google Drive is read-only from BigQuery
- Performance may be slower than native tables for large datasets

## Troubleshooting

### Common Issues

1. **Permission Denied**: 
   - Ensure the spreadsheet is shared with the correct permissions
   - Check if BigQuery service account has access

2. **Schema Detection Issues**:
   - Try setting `autodetect_schema = false` and define schema manually
   - Ensure data types are consistent in your spreadsheet

3. **Invalid Range**:
   - Verify the sheet name exists
   - Check if the specified range is valid

## Cleanup

To destroy the created resources:
```bash
terraform destroy
```

## Resources Created

- BigQuery Dataset
- BigQuery External Table
- IAM bindings (if specified)
- Service Account (if enabled)

## Security Best Practices

1. Use least privilege access for IAM permissions
2. Regularly review access to both BigQuery and Google Drive resources
3. Consider using VPC Service Controls for additional security
4. Monitor access logs for unusual activity
terraformのテスト用
