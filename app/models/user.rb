class User < ActiveRecord::Base
	include BCrypt
	has_many :comments

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

  def create_user
	  @user = User.new(params[:user])
	  @user.password = params[:password]
	  @user.save!
	end

	# method to authenticate the password
	def authenticate(password)
		self.password == password
	end
end
