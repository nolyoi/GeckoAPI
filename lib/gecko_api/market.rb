 # Base API URI. Append coin name for individual details.
# https://api.coingecko.com/api/v3/coins/
# 
# Append for marketcap
# markets?vs_currency=usd

class Market
	attr_accessor :id, :name, :symbol, :price, :description, :market_cap, :algo, :github, :website, :block_time, :block_explorer, :api_address, :price_movement_24h, :market_cap_rank, :image
	BASE_URL =- "https://api.coingecko.com/api/v3/coins/"
	@@market = []

	def initialize(coin)
			@id = coin["id"]
			@name = coin["name"]
			@symbol = coin["symbol"]
			@image = coin["image"]
			@price = coin["current_price"].to_s
			@price_movement_24h = coin["price_change_percentage_24h"]
			@market_cap = coin["market_cap"].to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
			@market_cap_rank = coin["market_cap_rank"]
			@api_address = "#{BASE_URL}#{coin["id"]}"
			@description = nil
			@github = nil
			@website = nil
			@algo = nil
			@block_time = nil
			@block_explorer = nil
			@@market << self
	end

	def self.all
		@@market
	end

	def self.get_market
		data = JSON.parse(open(BASE_URL + "markets?vs_currency=usd").read)

		data.each do |coin|
			Market.new(coin)
		end
	end

	def coin_data
			data = JSON.parse(open(self.api_address).read)
			@description = data["description"]["en"].gsub(/<[^"\\] href="/, '(').gsub(/["\\]>/, ') ').gsub(/<[^<\\]a>/, '')
			@github = data['links']['repos_url']['github'][0]
			@website = data['links']['homepage'][0]
			@algo = data['hashing_algorithm']
			@block_time = data['links']['blockchain_site'][0]
			@block_explorer = data['block_time_in_minutes'] 
	end

	def self.update
		Market.top
		Controller.menu
	end

	def self.top
		i = 0
		rows = [] # rows for terminal-table

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
	end

	def self.coin_info(input)
		@@market.each do |coin|
			if coin.market_cap_rank == input.to_i
				coin.coin_data
			else
				puts "."
			end
		end
			# if data["market_data"]["price_change_percentage_24h"] > 0
			# 	puts symbol.asciify(data["symbol"].upcase)
			# 	print "#{data["name"].colorize(:green)} (#{data["symbol"].upcase.colorize(:green)}) " + "$".colorize(:green) + "#{data["market_data"]["current_price"]["usd"].to_s.colorize(:green)} - #{data["market_data"]["price_change_percentage_24h"].round(2).to_s.colorize(:green)}" + "%".colorize(:green)
			# 	coin_description_title = coin_description_title.colorize(:green)
			# else
			# 	print "#{data["name"].colorize(:red)} (#{data["symbol"].upcase.colorize(:red)}) " + "$".colorize(:red) + "#{data["market_data"]["current_price"]["usd"].to_s.colorize(:red)} - #{data["market_data"]["price_change_percentage_24h"].round(2).to_s.colorize(:red)}" + "%".colorize(:red)
			# 	coin_description_title = coin_description_title.colorize(:red)
			# end

	end

end

