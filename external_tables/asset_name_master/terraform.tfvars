project_id  = "trading-prod-468212"
dataset_id  = "TEMP" # tradingが本番,TEMPが開発用
table_id    = "raw_asset_name_master"
source_uris = ["https://docs.google.com/spreadsheets/d/15ICFHR24bM19dKYw-TT9fjBwvR8DysapOOqWgK1kqZk"]
sheet_range = "master_asset_name!A:C"

table_schema = [
  {
    name        = "ticker"
    type        = "STRING"
    mode        = "NULLABLE"
    description = "ticker名"
  },
  {
    name        = "asset_type"
    type        = "STRING"
    mode        = "NULLABLE"
    description = "アセット種別(株,金利..)"
  },
  {
    name        = "asset_name"
    type        = "STRING"
    mode        = "NULLABLE"
    description = "アセット名"
  }
]