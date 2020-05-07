
class Controller
	def call
		name = "GeckoAPI"
		puts "#{File.open("art.txt").read}\n"
		welcome = "Welcome to the #{name.colorize(:green)} CLI!"
		puts welcome

		Controller.menu	
	end

	def self.menu
		puts "Type 'market <currency symbol>' to view top coins by market cap." 
		puts "Type '<coin rank>' to view detailed information about a single asset."

		input = gets.chomp
		integer_input = input.to_i
		
		if integer_input > 0 and integer_input < 101
			Market.coin(input)
		else
			case input.to_s
				when "back"
					Controller.clear_term
					Market.top
				when "top"
					Market.new
					Market.top	
				when "update"
					Market.new
					Market.top	
				when "menu"
					Controller.clear_term
					Market.new
				else
					puts "Invalid command. Please try again!".colorize(:red)
					Controller.menu
					
			end	
		end
	end

	def watchlist_new_error
		puts "Sorry, we could not find " + id + "in the top 100 crypto projects. Please check your spelling or search for another coin!"

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