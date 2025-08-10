# Terraformの設定ブロック
# このプロジェクトで使用するTerraformのバージョンとプロバイダーを定義
terraform {
  # 必要なTerraformのバージョンを指定（1.6.0以上）
  required_version = ">= 1.6.0"

  # 使用するプロバイダーとそのバージョンを指定
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.40"
    }
  }
}

# Google Cloudプロバイダーの設定
# 接続先のプロジェクトとリージョンを指定
provider "google" {
  project     = var.project_id
  region      = var.region
  credentials = var.google_credentials
}

# BigQuery APIの有効化
# BigQueryを使用するために必要なAPIサービスを有効にする
resource "google_project_service" "bigquery" {
  project            = var.project_id
  service            = "bigquery.googleapis.com"
  disable_on_destroy = false
}

# Google Drive APIの有効化
# Google Driveからデータを読み取るために必要なAPIを有効にする
resource "google_project_service" "drive" {
  project            = var.project_id
  service            = "drive.googleapis.com"
  disable_on_destroy = false
}

# Google Driveスプレッドシートの外部テーブル作成
# BigQueryから直接Google Driveのスプレッドシートを読み取るテーブルを定義
resource "google_bigquery_table" "external_sheet" {
  project             = var.project_id
  dataset_id          = var.dataset_id
  table_id            = var.table_id
  deletion_protection = false

  # 外部データの設定ブロック
  external_data_configuration {
    source_format = "GOOGLE_SHEETS"
    autodetect    = false
    source_uris   = var.source_uris

    # Google Sheets固有のオプション設定
    google_sheets_options {
      range             = var.sheet_range
      skip_leading_rows = 1
    }
  }

  # スキーマの手動定義
  # variables.tf で定義されたスキーマ変数を使用
  schema = jsonencode(var.table_schema)

  # 依存関係の定義
  # BigQueryとDrive APIが有効化されてからテーブルを作成
  depends_on = [
    google_project_service.bigquery,
    google_project_service.drive
  ]
}
