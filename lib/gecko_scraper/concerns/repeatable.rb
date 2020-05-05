module Repeatable
	def menu
		puts "Type 'market <currency symbol>' to view top coins by market cap." 
		puts "Type '<coin name>' to view detailed information about a single asset."

		input = gets.chomp
		# input.to_i unless input.match(/[^[:digit:]]+/)
		# if input.numeric? == true
		# 	data[input - 1]["name"]
		# else
		case input
			when "back"
				clear_term
				GeckoScraper::Controller.new.call
			when "market usd"
				Market.top_usd
			when "market jpy"
				Market.top_jpy
			when "bitcoin"
				clear_term
				Market.coin("bitcoin")
		end	
	end

	def clear_term
   		puts "amit"
   		if RUBY_PLATFORM =~ /win32|win64|\.NET|windows|cygwin|mingw32/i
      		system('cls')
    	else
      		system('clear')
   		end
	end

	# def numeric?
 #  		match(/\A[+-]?\d+?(_?\d+)*(\.\d+e?\d*)?\Z/) == nil ? false : true
	# end

end