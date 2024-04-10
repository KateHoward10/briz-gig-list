class User < ApplicationRecord
  has_many :tokens, dependent: :destroy

  def self.from_omniauth(auth)
    user = where(email: auth.info.email).first_or_initialize do |record|
      record.uid = auth.uid
      record.name = auth.info.name
      record.email = auth.info.email
      record.image = auth.info.image
    end
    user.new_record? && user.save
    user
  end
  
  def google_token
    tokens.find_by(provider: 'google')
  end
end