class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  symbolize :gender, in: [:m, :f], allow_blank: true, allow_nil: true

  has_many :places, class_name: "Place"
  has_many :services, class_name: "Service"
  has_many :transactions, class_name: "Transaction"
  has_many :widgetables
  has_many :widgets, through: :widgetables
  has_many :meters

  def valid_password?(password)
    if self.encrypted_password.present?
      if ::Digest::MD5.hexdigest(password).upcase == self.encrypted_password
        self.password = password
        #self.legacy_password_hash = nil
        self.save!
        true
      else
        false
      end
    else
      super
    end
  end

  def reset_password!(*args)
    #self.legacy_password_hash = nil
    super
  end
end
