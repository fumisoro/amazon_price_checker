# ログ出力先ファイルを指定
set :output, 'log/crontab.log'
# ジョブ実行環境を指定
set :environment, :development

# rbenvの設定を反映させる
# https://github.com/javan/whenever/issues/486
job_type :rbenv_rake, %Q{export PATH=$HOME/.rbenv/shims:$PATH; eval "$(rbenv init -)"; cd :path && :environment_variable=:environment :bundle_command rake :task --silent :output }


# [例] 1時間に1回
every 5.minute do
  # bash コマンドの実行例
  rbenv_rake "amazon_price_check:do"
end

# [例] 毎日04:30
# every 1.day, at: '4:30 am' do
#   # rake タスクの実行例
#   rake 'redline:send_reminder users=1 days=3 RAILS_ENV=production'
# end

# # [例] 毎週日曜18:00
# every :sunday, at: '18:00' do
#   # Rails 内のメソッド実行例
#   runner 'MyController.method_hoge'
# end

# # [例] 毎週月曜〜金曜06:00（crontab 形式）
# every '0 6 0 0 1-5 ' do
#   # script の実行
#   script '/home/hoge/rails_project/lib/assets/piyo.sh'
# end
