raw_parameters = { database_name: 'jb', company_name: "Jordan's Company" }
parameters = ActionController::Parameters.new(raw_parameters)

account = Account.create(parameters.permit(:database_name, :company_name))

Apartment::Database.switch('jb')

user = User.new

user.first_name            = "Jordan"
user.last_name             = "Byron"
user.email                 = "jordan.byron@gmail.com"
user.password              = "temp123456"
user.password_confirmation = "temp123456"

user.save
