class ShortenedUrl < ActiveRecord::Base
  validates :short_url, :long_url, :submitter, presence: true
  validates :short_url, uniqueness: true

  belongs_to :submitter,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :User

  has_many :visits,
    primary_key: :id,
    foreign_key: :url_id,
    class_name: :Visit

  has_many :visitors,
    Proc.new { distinct },
    through: :visits,
    source: :user

  def self.random_code
    c = SecureRandom.urlsafe_base64(16)
    if ShortenedUrl.exists?(:short_url => c)
      c = self.random_code
    end
    return c
  end

  def self.create_for(user, l)
    ShortenedUrl.create!(user_id: user.id, long_url: l, short_url: ShortenedUrl.random_code)
  end

  def num_clicks
    visits.count
  end

  def num_uniques
    visits.select('user_id').distinct.count
  end

  def num_recent_uniques
    visits.select('user_id').where({created_at: (Time.now)..10.minutes.ago}).distinct.count
  end
end
