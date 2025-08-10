# はじめに
- terraformの諸々をテストしてみる用のレポジトリ

# メモ
- bigqueryのアップロード先datasetは`TEMP`にする
- ディレクトリの第一階層はGCPのサービス名のイメージ
  - でも、bigqueryだけは`external_tables`みたいな個別サービス？にする

# Terraform コマンド概要

## 1. `terraform fmt`（Format）
- **役割**：Terraform設定ファイル（`.tf`や`.tfvars`）を公式スタイルに整形
- **詳細**：
  - インデントやスペースの揃え
  - 属性の並び順統一
  - コメントや改行位置の調整（値は変更しない）
- **目的**：
  - コードスタイル統一
  - レビューの差分を見やすくする
- **例**：
```hcl
# 整形前
variable "region" { type = string  default = "asia-northeast1" }

# 整形後
variable "region" {
  type    = string
  default = "asia-northeast1"
}
```

## 2. `terraform plan`（Plan）

- **役割**：現在のインフラ状態と `.tf` ファイルの差分を比較し、「何を変更するか」の計画を出力

- **詳細**：
  - 現在の state ファイルとクラウドの実際の状態を取得
  - コードとの差分を計算
  - 作成 / 更新 / 削除のリストを表示

- **目的**：
  - 実行前に影響範囲を確認
  - 予期せぬ変更を防止

- **例**：
```txt
# google_storage_bucket.example will be created
+ resource "google_storage_bucket" "example" {
    name     = "my-bucket"
    location = "US"
  }
Plan: 1 to add, 0 to change, 0 to destroy.
```

## 3. `terraform apply`（Apply）

- **役割**：`plan`で表示された内容を実際にインフラに適用

- **詳細**：
  - 作成・更新・削除のAPIを実行
  - 実行後の状態を `terraform.tfstate` に記録

- **実行方法**：
  - `terraform apply` → その場でplan表示＆yes確認
  - `terraform apply tfplan` → 事前に保存したplanファイルを適用（CI/CD向け）

- **注意**：
  - 実際にリソースが変わるため、本番はplan確認後に実行

- **例**：
```txt
# google_storage_bucket.example will be created
+ resource "google_storage_bucket" "example" {
    name     = "my-bucket"
    location = "US"
  }
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```