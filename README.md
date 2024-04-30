# memo_app
メモを管理するアプリです。

## 使用方法
1. GitHubからアプリのリポジトリをローカルにクローンする。  
`git clone https://github.com/hagiya0121/memo_app.git`

2. PostgresSQLでデータベースを準備  
   * データベースを作成  
     `CREATE DATABASE memo_app;`

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

1. サーバーを起動する。  
`bundle exec ruby memo_app.rb`

1. ブラウザから以下のURLにアクセスする。  
`http://localhost:4567/`
