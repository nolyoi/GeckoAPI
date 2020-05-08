# Base API URI. Append coin name for individual details.
# https://api.coingecko.com/api/v3/coins/
# 
# Append for marketcap
# markets?vs_currency=usd

class Market
	attr_accessor :id, :name, :symbol, :price, :price_movement_24h, :market_cap_rank, :image
	BASE_URL =- "https://api.coingecko.com/api/v3/coins/"
	@@market = []
	@@list = []

	def initialize
		data = JSON.parse(open(BASE_URL + "markets?vs_currency=usd").read)
		i = 0

		# looping until we hit the end of the list. adding them all as objects.
		while i < data.length
			@id = data[i]["id"]
			@name = data[i]["name"]
			@symbol = data[i]["symbol"]
			@image = data[i]["image"]
			@price = data[i]["current_price"].to_s
			@price_movement_24h = data[i]["price_change_percentage_24h"]
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
		Market.top
		Controller.menu
	end

	def self.top
		i = 0
		rows = []
		@@market.each do |coin|
			if coin.price_movement_24h > 0
				rows << ["#{i +1}", "#{coin.name}", "#{coin.symbol.upcase}", "$#{coin.price.colorize(:green)}"]
				i += 1
			else
				rows << ["#{i +1}", "#{coin.name}", "#{coin.symbol.upcase}", "$#{coin.price.colorize(:red)}"]
				i += 1
			end
		end
		table = Terminal::Table.new :headings => ['Rank', 'Name', 'Symbol', 'Current Price'], :rows => rows
		puts table
		puts "==========================================="
		Controller.menu
	end

	def self.coin(number)
		a = Artii::Base.new :font => 'roman'
		puts "Searching"
		@@market.each do |coin|
			if coin.market_cap_rank.to_s == number
				id = coin.id
				data = JSON.parse(open(BASE_URL + id).read)
				Controller.clear_term
				if data["market_data"]["price_change_percentage_24h"] > 0
					puts a.asciify(data["symbol"].upcase)
					print "#{data["name"].colorize(:green)} (#{data["symbol"].upcase.colorize(:green)}) " + "$".colorize(:green) + "#{data["market_data"]["current_price"]["usd"].to_s.colorize(:green)} - #{data["market_data"]["price_change_percentage_24h"].round(2).to_s.colorize(:green)}" + "%".colorize(:green)
				else
					print "#{data["name"].colorize(:red)} (#{data["symbol"].upcase.colorize(:red)}) " + "$".colorize(:red) + "#{data["market_data"]["current_price"]["usd"].to_s.colorize(:red)} - #{data["market_data"]["price_change_percentage_24h"].round(2).to_s.colorize(:red)}" + "%".colorize(:red)
				end


				mktcap = data['market_data']['market_cap']['usd'].to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse

				# formatting the marketcap number. taking the first 6 numbers of the string.
				puts " "
				puts "Total Market Cap: $#{mktcap}"
				puts "Website: #{data['links']['homepage'][0]}"
				puts "Block Explorer: #{data['links']['blockchain_site'][0]}"
				puts "GitHub: #{data['links']['repos_url']['github'][0]}"
				puts "Mining Algorithm: #{data['hashing_algorithm']}"
				puts "Block Time (minutes): #{data['block_time_in_minutes']}"
				puts " "
				puts "Description:".colorize(:red)
				# project description formatting. removing HTML elements but keeps links within parentheses
				description = data["description"]["en"]
				puts description.gsub(/<[^"\\] href="/, '(').gsub(/["\\]>/, ') ').gsub(/<[^<\\]a>/, '')

			else
				print "."
			end
		end
		puts " "
		Controller.menu
	end
end

