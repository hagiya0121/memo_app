# memo_app
メモを管理するアプリです。

## 使用方法
1. GitHubからアプリのリポジトリをローカルにクローンする。  
`git clone https://github.com/hagiya0121/memo_app.git`

2. データベースの準備
PostgresSQLのCLIで下記のコマンドでデータベースを作成。
* データベースを作成  
  `CREATE DATABASE memo_app;`
* データベースを切り替え  
  `¥C memo_app`
* テーブルを作成
  ```
  CREATE TABLE memos (
    id SERIAL PRIMARY KEY,
    title VARCHAR,
    content VARCHAR
  );
  ```

3. クローンしたディレクトリに移動して、Bundlerを使ってgemをインストールする。  
`bundle`

4. サーバーを起動する。  
`bundle exec ruby memo_app.rb`

5. ブラウザから以下のURLにアクセスする。  
`http://localhost:4567/`
