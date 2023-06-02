namespace :credit_packs do
  desc 'create a credit packfrom the command line'
  task new: :environment do
    puts 'Enter the details credit pack'
    new_credit_pack = CreditPack.new do |credit_pack|
      puts 'No of Credits in the Pack:'
      credit_pack.credit_amount = $stdin.gets.chomp
      puts 'Price (in ₹):'
      credit_pack.price = $stdin.gets.chomp
      puts 'Description:'
      credit_pack.description = $stdin.gets.chomp
    end
    if new_credit_pack.save
      puts 'Credit pack created successfully'
    else
      puts 'The following errors prevented the Credit Pack from being saved'
      new_credit_pack.errors.each do |error|
        puts "- #{error.full_message}"
      end
    end
  end
end
