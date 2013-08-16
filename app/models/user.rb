class User < ActiveRecord::Base
  has_secure_password
  validates_uniqueness_of :email
  before_create do
    generate_token(:auth_token)
    generate_token(:api_token)
  end
    
  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end
  
  def new_password(params)
    update_attributes params.merge(password_reset_token: nil)
  end
  
  def regenerate_api_token
    generate_token(:api_token)
    save!
  end

  private
    def generate_token(column)
      begin
        self[column] = SecureRandom.urlsafe_base64
      end while User.exists?(column => self[column])
    end
end
