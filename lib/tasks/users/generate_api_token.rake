namespace :users do
  desc 'add api_token to existing users'
  task generate_api_token: :environment do
    User.all.each do |user|
      user.update!(api_token: user.generate_token(:api))
      p "#{user.email} 's api_token updated"
    end
  end
end
