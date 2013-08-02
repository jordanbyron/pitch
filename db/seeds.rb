raw_parameters = { subdomain: 'jb', company_name: "Jordan's Company" }
parameters = ActionController::Parameters.new(raw_parameters)

account = Account.create(parameters.permit(:database_name, :company_name))

user = User.new

user.first_name            = "Jordan"
user.last_name             = "Byron"
user.email                 = "jordan.byron@gmail.com"
user.password              = "temp123456"
user.password_confirmation = "temp123456"
user.account_id            = account.id

user.save
