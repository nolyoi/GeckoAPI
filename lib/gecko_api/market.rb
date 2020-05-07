# Base API URI. Append coin name for individual details.
# https://api.coingecko.com/api/v3/coins/
# 
# Append for marketcap
# markets?vs_currency=usd

class Market
	attr_accessor :id, :name, :symbol, :description, :algo, :price, :price_movement_24h, :market_cap, :market_cap_rank
	BASE_URL =- "https://api.coingecko.com/api/v3/coins/"
	@@market = []
	@@list = []

	def initialize
		data = JSON.parse(open(BASE_URL + "markets?vs_currency=usd").read)
		i = 0

		# looping until we hit the end of the list. adding them all as objects.
		while i < data.length
			@id = data[i]["id"].to_s
			@name = data[i]["name"].to_s
			@symbol = data[i]["symbol"].to_s
			@price = data[i]["current_price"].to_s
			@price_movement_24h = data[i]["price_change_percentage_24h"]
			@market_cap = data[i]["market_cap"].to_s
			@market_cap_rank = data[i]["market_cap_rank"]
			@@market << self.dup
			i += 1
		end
	end

	def self.all
		@@market
	end

	def self.update
		@@market = []
		Market.new
	end

	def self.top
		i = 0
		@@market.each do |coin|
			if coin.price_movement_24h > 0
				puts "#{i +1}. #{coin.name} (#{coin.symbol.upcase}) - $#{coin.price.colorize(:green)}"
				i += 1
			else
				puts "#{i +1}. #{coin.name} (#{coin.symbol.upcase}) - $#{coin.price.colorize(:red)}"
				i += 1
			end
		end
		puts "==========================================="
		puts "Type a coin ticker, ex. 'BTC', for more information or 'back' to return to the main menu."
		Controller.menu
	end

	def self.coin(number)
		puts "Searching"
		@@market.each do |coin|
			if coin.market_cap_rank.to_s == number
				id = coin.id
				data = JSON.parse(open(BASE_URL + id).read)
				Controller.clear_term
				if data["market_data"]["price_change_percentage_24h"] > 0
					print "#{data["name"].to_s.colorize(:red)} (#{data["symbol"].to_s.upcase.colorize(:red)}) " + "$".colorize(:green) + "#{data["market_data"]["current_price"]["usd"].to_s.colorize(:green)} - #{data["market_data"]["price_change_percentage_24h"].round(2).to_s.colorize(:green)}" + "%".colorize(:green)
				else
					print "#{data["name"].to_s.colorize(:red)} (#{data["symbol"].to_s.upcase.colorize(:red)}) " + "$".colorize(:green) + "#{data["market_data"]["current_price"]["usd"].to_s.colorize(:red)} - #{data["market_data"]["price_change_percentage_24h"].round(2).to_s.colorize(:red)}" + "%".colorize(:red)
				end

				# number formatting. making more human readable. outputs X.XXX Million/Billion
				if data["market_data"]["market_cap"]["usd"].digits.length > 11 
					mktcap = "Billion"
				else
					mktcap = "Million"
				end

				# formatting the marketcap number. taking the first 6 numbers of the string.
				puts " "
				puts "Total Market Cap: $#{data["market_data"]["market_cap"]["usd"].to_s[0..5].insert(-4, ".")} #{mktcap}"

				# project description formatting. removing HTML elements like a hrefs
				puts "#{data["description"]["en"]}"
			else
				print "."
			end
		end
		puts " "
		Controller.menu
	end
end

