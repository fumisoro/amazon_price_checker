require 'open-uri'
require "slack"

namespace :amazon_price_check do
  desc "アマゾンの在庫確認"
  task do: :environment do
    opt = {}
    opt['User-Agent'] = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) chrome'
    client = Slack::Client.new token: Settings.slack.token

    Product.all.each do |product|
      charset = nil
      html = open(product.url, opt) do |f|
        charset = f.charset # 文字種別を取得
        f.read # htmlを読み込んで変数htmlに渡す
      end
      doc = Nokogiri::HTML.parse(html, nil, charset)
      price = doc.css("#olp_feature_div > div > span > span").text
      value = price.gsub(/[^\d]/, "").to_i
      # p doc.css("#priceblock_ourprice").text
      # p doc.css("#unqualifiedBuyBox > div > div.a-text-center.a-spacing-mini > span").text
      if product.prices.last.value > value
        text = <<-EOS
<@#{Settings.slack.owner_id}>
#{product.prices.last.value - value}円安くなったやで！！！
#{product.prices.last.value_string} → #{price}
今すぐ買お💪
#{product.url}
        EOS

        client.chat_postMessage(channel: Settings.slack.channel_id, text: text)
      end
      product.prices.create(value: value, value_string: price)
    end
  end
end
