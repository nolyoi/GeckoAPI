
class Controller
	def call
		name = "GeckoAPI"
		welcome = "Welcome to the #{name.colorize(:green)} CLI!"
		
		puts "#{File.open("art.txt").read}\n"
		puts welcome
		sleep(2)

		Market.new
		Market.top
		puts "==========================================="
		Controller.menu

	end

	def self.menu
		puts "Type a number 1-100 to view detailed information about a single asset. Type 'update' to refresh prices. Type 'back' to go back."

		input = gets.chomp
		
		if input.to_i > 0 and input.to_i < 101
			Controller.clear_term
			Market.coin(input)
			Controller.menu
		else
			case input.to_s
				when "back"
					Controller.clear_term
					Market.top
				when "top"
					Market.new
					Market.top	
					puts "==========================================="
					Controller.menu
				when "update"
					Market.update
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