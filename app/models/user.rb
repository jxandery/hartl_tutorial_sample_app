class User < ActiveRecord::Base
  before_save { email.downcase! }

  validates :name, presence: true, length: { in: 6..50 }
  validates :email, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }
  validates_format_of :email, {with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i }
  has_secure_password
end
