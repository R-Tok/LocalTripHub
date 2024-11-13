class User < ApplicationRecord
  authenticates_with_sorcery!

  before_save :store_password_length, if: :crypted_password_changed?

  validates :password, length: { minimum: 6 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :nickname, presence: true, length: { maximum: 255 }
  validates :introduction, length: { maximum: 5000 }
  validates :email, presence: true, uniqueness: true

  has_many :spots
  has_many :posts, dependent: :destroy

  mount_uploader :avatar, AvatarUploader

  def own?(object)
    object.user_id === id
  end

  def active_for_authentication?
    is_deleted == false
  end

  private

  def store_password_length
    # `password` には暗号化前のパスワードが入っている想定
    self.password_length = password.length if password.present?
  end
end
