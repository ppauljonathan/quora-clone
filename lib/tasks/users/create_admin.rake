namespace :users do
  desc 'create an admin user from the command line'
  task create_admin: :environment do
    puts 'Enter the details of admin user'
    user = User.new do |user|
      puts 'Name:'
      user.name = STDIN.gets.chomp
      puts 'Email:'
      user.email = STDIN.gets.chomp
      puts 'Password:'
      user.password = STDIN.noecho(&:gets).chomp
      puts 'Password Confirmation:'
      user.password_confirmation = STDIN.noecho(&:gets).chomp
      user.verified_at = Time.now
      user.is_admin = true
      user.credits = 5
    end
    if user.save
      puts 'User created successfully'
    else
      puts 'The following errors prevented the user from being saved'
      user.errors.each do |error|
        puts "- #{ error.full_message }"
      end
    end
  end
end
