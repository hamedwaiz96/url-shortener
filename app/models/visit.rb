class Visit < ActiveRecord::Base
  validates :visitor, :shortened_url, presence: true

  belongs_to :shortened_url

  belongs_to :visitor,
    class_name: :User,
    foreign_key: :submitter_id,
    primary_key: :id

  def self.record_visit!(user, shortened_url)
    Visit.create!(submitter_id: user.id, url_id: shortened_url.id)
  end
end
