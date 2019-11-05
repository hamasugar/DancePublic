# Dancyについて
ダンスマッチングアプリDancyの公開用レポジトリです。本来は非公開ですが就活のために公開してあります。パスワードなどが隠れているのでところどころ整合性がとれないところがございます。
過去のコミット履歴も全て取り消しておりますので、ご了承ください。詳しくはこちら
https://qiita.com/hamazi511/items/ce55d6b482cef4d2cd4c

ダンスを習いたいが、ダンスの教室に行く勇気がない人と、ダンスを教えたい人を結びつけるiOSのマッチングサービスです。ダンスは音楽に合わせて踊り、運動量が大きいためダイエットにも大きな効果が見込まれます。ダンサーを目指す人は経済的に不安定だったり、アルバイトで食いつなぐ人も非常に多い世界だそうです。界隈で知名度のあるダンサーであっても月収が10万円代前半というのも珍しくないそうです。「ダンサーがダンス一本で生活できる社会にする」「日本でもっと広くダンスが受け入れられるようにする」という2つの目標を掲げて事業がスタートしました。比較的お金がある中高年の人と、お金のない若いダンサーを繋げるプロジェクトの一環として開発を続け、アップルストアにリリースしました。


https://apps.apple.com/jp/app/dancy/id1468729980

公式Twitterアカウントはこちら
<blockquote class="twitter-tweet" data-lang="ja"><p lang="ja" dir="ltr">Apple Storeで <a href="https://twitter.com/hashtag/dancy?src=hash&amp;ref_src=twsrc%5Etfw">#dancy</a> と検索！！<a href="https://twitter.com/hashtag/%E3%83%80%E3%83%B3%E3%82%B9?src=hash&amp;ref_src=twsrc%5Etfw">#ダンス</a> <a href="https://twitter.com/hashtag/%E3%83%80%E3%83%B3%E3%82%B5%E3%83%BC?src=hash&amp;ref_src=twsrc%5Etfw">#ダンサー</a> <a href="https://twitter.com/hashtag/%E3%83%9E%E3%83%83%E3%83%81%E3%83%B3%E3%82%B0%E3%82%A2%E3%83%97%E3%83%AA?src=hash&amp;ref_src=twsrc%5Etfw">#マッチングアプリ</a> <a href="https://twitter.com/hashtag/dance?src=hash&amp;ref_src=twsrc%5Etfw">#dance</a> <a href="https://twitter.com/hashtag/dancer?src=hash&amp;ref_src=twsrc%5Etfw">#dancer</a> <a href="https://t.co/dNbJ0KILm3">pic.twitter.com/dNbJ0KILm3</a></p>&mdash; dancy -ダンスマッチングアプリ- (@dancy_matching) <a href="https://twitter.com/dancy_matching/status/1141614864898465792?ref_src=twsrc%5Etfw">2019年6月20日</a></blockquote>

# Dependency
-Swift 5.0
-Node.js 8.10.0

-Alamofire
-SwiftyJSON,
-Stripe,
-Cosmos

API Gateway + Lambda + DynamoDBという典型的なサーバーレスの構成です。

# セットアップ
iOS11.0以降で動作します。ダークモードへの対応は完了していません。


# 使い方
1. アプリを開き、講師一覧の中から良さそうな講師を見つける
2. 会員登録をして、プロフィールを記入する
3. 講師の画面から「話を聞いてみたい」ボタンを押して講師からの連絡を待つ
4. レッスン内容や日時、場所、レッスン料を話合いレッスンを申し込む
５.　ダンスのレッスンを受ける
6. レッスンが終わったらその場でアプリ内でクレジットカードを用いて決済を完了させる

# ライセンス
This software is released under the MIT License, see LICENSE.
