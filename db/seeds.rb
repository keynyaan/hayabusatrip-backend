prefecture_names = %w[
  hokkaido aomori iwate miyagi akita yamagata fukushima
  ibaraki tochigi gunma saitama chiba tokyo kanagawa
  niigata toyama ishikawa fukui yamanashi nagano gifu
  shizuoka aichi mie shiga kyoto osaka hyogo nara
  wakayama tottori shimane okayama hiroshima yamaguchi
  tokushima kagawa ehime kochi fukuoka saga nagasaki
  kumamoto oita miyazaki kagoshima okinawa kaigai
]

prefecture_names.each do |name|
  Prefecture.find_or_create_by!(name: name) do |prefecture|
    prefecture.image_path = "#{ENV['CLOUDFRONT_DOMAIN']}/prefectures/#{name}.jpg"
  end
end
