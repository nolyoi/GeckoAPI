
class Controller
	def call
		name = "GeckoAPI"
		welcome = "Welcome to the #{name.colorize(:green)} CLI!"
		
		puts "#{File.open("art.txt").read}\n"
		puts welcome
		sleep(2)
		Market.get_market
		Market.top
		Controller.menu
	end

	def self.menu
		puts " "
		puts "==========================================="
		puts " "
		puts "Type a number 1-100 to view detailed information about a single asset."
		puts "Type 'update' to refresh prices. Type 'back' to go back."
		puts " "
		puts "==========================================="
		input = gets.chomp
		
		if input.to_i > 0 and input.to_i < 101
			Controller.clear_term
			Market.coin_info(input)
			coin = Market.all[input.to_i - 1]
			
			if coin.percent_change.to_i > 0
				a = Artii::Base.new :font => 'colossal'
				puts a.asciify(coin.symbol.upcase)
				print "#{coin.name.colorize(:green)} (#{coin.symbol.upcase.colorize(:green)}) " + "$".colorize(:green) + "#{coin.price.to_s.colorize(:green)} - #{coin.percent_change.round(2).to_s.colorize(:green)}" + "%".colorize(:green)
			else
				print "#{coin.name.colorize(:red)} (#{coin.symbol.upcase.colorize(:red)}) " + "$".colorize(:red) + "#{coin.price.to_s.colorize(:red)} - #{coin.percent_change.round(2).to_s.colorize(:red)}" + "%".colorize(:red)
			end

			puts " "
			puts "Total Market Cap: $#{coin.market_cap}"
			puts "Website: #{coin.website}"
			puts "Block Explorer: #{coin.block_explorer}"
			puts "GitHub: #{coin.github}"
			puts "Mining Algorithm: #{coin.algo}"
			puts "Block Time (minutes): #{coin.block_time}"
			puts " "
			puts "Description"
			puts " "

			# project description formatting. removing HTML elements but keeps links within parentheses
			puts coin.description.gsub(/<[^"\\] href="/, '(').gsub(/["\\]>/, ') ').gsub(/<[^<\\]a>/, '')

			puts " "
			Controller.menu
		else
			case input.to_s
				when "back"
					Controller.clear_term
					Market.top
					Controller.menu
				when "top"
					Market.top	
					Controller.menu
				when "update"
					Market.update
					Market.top
					Controller.menu
				else
					puts "Invalid command. Please try again!".colorize(:red)
					Controller.menu		
			end	
		end
	end

	# resets the terminal history. makes the pages cleaner and more readable. checks platform to run correct command.
	def self.clear_term
   		puts "amit"
   		if RUBY_PLATFORM =~ /win32|win64|\.NET|windows|cygwin|mingw32/i
      		system('cls')
    	else
      		system('clear')
   		end
	end
end

