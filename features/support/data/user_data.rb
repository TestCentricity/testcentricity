class UserDataSource < TestCentricity::DataSource
  def find_user_creds(node_name)
    UserData.current = UserData.new(environs.read('User_creds', node_name))
  end
end


class UserData < TestCentricity::DataPresenter
  attribute :username, String
  attribute :password, String

  def initialize(data)
    @username = data[:username]
    @password = data[:password]
    super
  end
end
