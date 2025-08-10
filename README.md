# はじめに
- terraformの諸々をテストしてみる用のレポジトリ

# メモ
- bigqueryのアップロード先datasetは`TEMP`にする
- ディレクトリの第一階層はGCPのサービス名のイメージ
  - でも、bigqueryだけは`external_tables`みたいな個別サービス？にする