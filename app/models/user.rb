class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  #devise :database_authenticatable, :registerable,
  #       :recoverable, :rememberable, :validatable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  #devise :database_authenticatable, :registerable,
  #       :recoverable, :rememberable, :validatable
  
  devise :trackable, :omniauthable, omniauth_providers: %i(google)

  protected
  def self.find_for_google(auth)
    logger.debug("Logging in as %s" % auth.info.email)
    user = User.find_by(email: auth.info.email)

    unless user
      user = User.create(name:     auth.info.name,
                         email:    auth.info.email,
                         provider: auth.provider,
                         uid:      auth.uid,
                         token:    auth.credentials.token,
                         avatar_url: auth.extra.raw_info.picture,
                         encrypted_password: Devise.friendly_token[0, 20],
                         meta:     auth.to_yaml)
    end
    user
  end

end
