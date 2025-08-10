project_id  = "trading-prod-468212"
dataset_id  = "TEMP" # tradingが本番,TEMPが開発用
table_id    = "raw_asset_status_history"
source_uris = ["https://docs.google.com/spreadsheets/d/15ICFHR24bM19dKYw-TT9fjBwvR8DysapOOqWgK1kqZk"]
sheet_range = "asset_status_history!A:D"

table_schema = [
  {
    name        = "event_time_jst_str"
    type        = "STRING"
    mode        = "NULLABLE"
    description = "ステータス変更日時(JST)"
  },
  {
    name        = "ticker"
    type        = "STRING"
    mode        = "NULLABLE"
    description = "ticker名"
  },
  {
    name        = "is_monitor"
    type        = "BOOLEAN"
    mode        = "NULLABLE"
    description = "モニタリング対象フラグ"
  },
  {
    name        = "is_watch"
    type        = "BOOLEAN"
    mode        = "NULLABLE"
    description = "取引対象フラグ"
  }
]