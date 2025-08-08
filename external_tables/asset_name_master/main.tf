# Terraformの設定ブロック
# このプロジェクトで使用するTerraformのバージョンとプロバイダーを定義
terraform {
  # 必要なTerraformのバージョンを指定（1.6.0以上）
  required_version = ">= 1.6.0"
  
  # 使用するプロバイダーとそのバージョンを指定
  required_providers {
    google = {
      source  = "hashicorp/google"  # Google Cloudプロバイダーのソース
      version = "~> 5.40"           # バージョン5.40系を使用
    }
  }
}

# Google Cloudプロバイダーの設定
# 接続先のプロジェクトとリージョンを指定
provider "google" {
  project = var.project_id  # 変数で指定されるプロジェクトIDを使用
  region  = var.region      # 変数で指定されるリージョンを使用
}

# BigQuery APIの有効化
# BigQueryを使用するために必要なAPIサービスを有効にする
resource "google_project_service" "bigquery" {
  project            = var.project_id              # 対象プロジェクト
  service            = "bigquery.googleapis.com"   # BigQuery APIのサービス名
  disable_on_destroy = false                       # Terraform destroyでもAPIを無効化しない
}

# Google Drive APIの有効化
# Google Driveからデータを読み取るために必要なAPIを有効にする
resource "google_project_service" "drive" {
  project            = var.project_id         # 対象プロジェクト
  service            = "drive.googleapis.com" # Google Drive APIのサービス名
  disable_on_destroy = false                  # Terraform destroyでもAPIを無効化しない
}

# BigQueryデータセットの作成
# 外部テーブルを格納するためのデータセット（データベースのようなもの）を作成
resource "google_bigquery_dataset" "this" {
  dataset_id = var.dataset_id # データセットの一意な識別子（例: "external_data"）
  location   = var.location   # データの保存場所（例: "US", "asia-northeast1"）
}

# Google Driveスプレッドシートの外部テーブル作成
# BigQueryから直接Google Driveのスプレッドシートを読み取るテーブルを定義
resource "google_bigquery_table" "external_sheet" {
  dataset_id          = google_bigquery_dataset.this.dataset_id # 上で作成したデータセットを参照
  table_id            = var.table_id                            # テーブルの名前（例: "sheet_a_data"）
  deletion_protection = false                                   # 削除保護を無効（テスト環境用）

  # 外部データの設定ブロック
  external_data_configuration {
    source_format = "GOOGLE_SHEETS"                # データソースの形式（Google Sheets）
    autodetect    = false                          # スキーマ（列の型）を手動で定義
    source_uris   = var.source_uris                # Google DriveスプレッドシートのURL配列

    # Google Sheets固有のオプション設定
    google_sheets_options {
      range = var.sheet_range  # 読み取り範囲（例: "シートA!A:Z" or "シートA!A1:D100"）
                               # 範囲を指定しない場合は、シート全体が対象
    }
  }

  # スキーマの手動定義
  # variables.tf で定義されたスキーマ変数を使用
  schema = jsonencode(var.table_schema)

  # 依存関係の定義
  # BigQueryとDrive APIが有効化されてからテーブルを作成
  depends_on = [
    google_project_service.bigquery,  # BigQuery APIの有効化を待つ
    google_project_service.drive      # Google Drive APIの有効化を待つ
  ]
}
