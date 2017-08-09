class Tweet < ApplicationRecord
  has_many :pictures

  # TwitterAPIを用いて同期
  def self.synchronize
    tl = Twitter.new.timeline(2000)
    p tl.count
    self.transaction do
      tl.each_with_index do |t, idx|
        puts "Tweet/Pictureレコード登録 残り: #{tl.count - idx}"
        tweet = self.find_or_initialize_by(origin_id: t[:origin_id]).update(t)
        Tweet.find_by(origin_id: t[:origin_id]).scrape_pictures_url
      end
    end
  end

  # HTTPを用いてツイートに添付される画像URLを同期
  def scrape_pictures_url
    return if self.pictures.present?
    pictures = Twitter.new.get_pictures_url(self.origin_id)
    pictures.each do |picture_url|
      unless self.pictures.where(url: picture_url).exists?
        self.pictures.create(url: picture_url)
      end
    end
  end

end
