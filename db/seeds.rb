account = Account.new

account.subdomain    = "jb"
account.company_name = "Jordan's Company"

account.save!

user = User.new

user.first_name            = "Jordan"
user.last_name             = "Byron"
user.email                 = "jordan.byron@gmail.com"
user.password              = "temp123456"
user.password_confirmation = "temp123456"
user.account_id            = account.id

user.save!
