namespace :admin do
  desc 'create an admin user from the command line'
  task new: :environment do
    puts 'Enter the details of admin user'
    new_user = User.new do |user|
      puts 'Name:'
      user.name = $stdin.gets.chomp
      puts 'Email:'
      user.email = $stdin.gets.chomp
      puts 'Password:'
      user.password = $stdin.noecho(&:gets).chomp
      puts 'Password Confirmation:'
      user.password_confirmation = $stdin.noecho(&:gets).chomp
      user.verified_at = Time.now
      user.is_admin = true
      user.credits = 5
    end
    if new_user.save
      puts 'User created successfully'
    else
      puts 'The following errors prevented the user from being saved'
      new_user.errors.each do |error|
        puts "- #{error.full_message}"
      end
    end
  end
end
