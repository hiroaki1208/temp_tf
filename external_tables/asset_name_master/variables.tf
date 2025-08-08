variable "project_id" { type = string }
variable "region" {
  type    = string
  default = "asia-northeast1"
}
variable "location" {
  type    = string
  default = "asia-northeast1"
} # BigQuery のリージョン/マルチリージョン
variable "dataset_id"  { type = string }
variable "table_id"    { type = string }
variable "source_uris" { type = list(string) } # Google Sheets のURL（1つでも配列で）
variable "sheet_range" {
  type    = string
  default = null
} # "シート1!A:Z" など

# BigQueryテーブルのスキーマ定義
# 各列の名前、データ型、モード（必須/任意）、説明を定義
variable "table_schema" {
  description = "BigQueryテーブルのスキーマ定義"
  type = list(object({
    name        = string # 列名
    type        = string # データ型 (STRING, INTEGER, NUMERIC, BOOLEAN, DATE, DATETIME, TIMESTAMP等)
    mode        = string # モード (REQUIRED, NULLABLE, REPEATED)
    description = string # 列の説明
  }))
}