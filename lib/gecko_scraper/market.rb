# https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd
# 

class Market
	extend Repeatable
	BASE_URL =- "https://api.coingecko.com/api/v3/coins/"
	@@coins = []

	def self.top_usd
		data = JSON.parse(open(BASE_URL + "markets?vs_currency=usd").read)
		i = 0
		# looping until we hit the end of the list. outputting name and price.
		while i < data.length
			if data[i]["price_change_24h"] > 0
				puts "#{i +1}. #{data[i]["name"]} (#{data[i]["symbol"].upcase}) - $#{data[i]["current_price"].to_s.colorize(:green)}"
				i += 1
			elsif data[i]["price_change_24h"] == 0
				puts "#{i +1}. #{data[i]["name"]} (#{data[i]["symbol"].upcase}) - $#{data[i]["current_price"].to_s.colorize(:yellow)}"
				i += 1
			else
				puts "#{i +1}. #{data[i]["name"]} (#{data[i]["symbol"].upcase}) - $#{data[i]["current_price"].to_s.colorize(:red)}"
				i += 1
			end
		end
		puts "==========================================="
		puts "Type a coin ticker, ex. 'BTC', for more information or 'back' to return to the main menu."
		Market.menu
	end

	def self.top_jpy
		data = JSON.parse(open(BASE_URL + "markets?vs_currency=jpy").read)
		i = 0
		# looping until we hit the end of the list. outputting name and price.
		while i < data.length
			if data[i]["price_change_24h"] > 0
				puts "#{i +1}. #{data[i]["name"]} (#{data[i]["symbol"].upcase}) - ¥#{data[i]["current_price"].to_s.colorize(:green)}"
				i += 1
			elsif data[i]["price_change_24h"] == 0
				puts "#{i +1}. #{data[i]["name"]} (#{data[i]["symbol"].upcase}) - ¥#{data[i]["current_price"].to_s.colorize(:yellow)}"
				i += 1
			else
				puts "#{i +1}. #{data[i]["name"]} (#{data[i]["symbol"].upcase}) - ¥#{data[i]["current_price"].to_s.colorize(:red)}"
				i += 1
			end

		end
		puts "==========================================="
		Market.menu
	end

	def self.coin(id)
		data = JSON.parse(open(BASE_URL + id).read)
		clear_term
		i = 0
		# looping until we hit the end of the list. outputting name and price.
		if data["market_data"]["price_change_percentage_24h"] > 0
			print "#{data["name"].to_s.colorize(:red)} (#{data["symbol"].to_s.upcase.colorize(:red)}) " + "$".colorize(:green) + "#{data["market_data"]["current_price"]["usd"].to_s.colorize(:green)} - #{data["market_data"]["price_change_percentage_24h"].round(2).to_s.colorize(:green)}" + "%".colorize(:green)
		else
			print "#{data["name"].to_s.colorize(:red)} (#{data["symbol"].to_s.upcase.colorize(:red)}) " + "$".colorize(:green) + "#{data["market_data"]["current_price"]["usd"].to_s.colorize(:red)} - #{data["market_data"]["price_change_percentage_24h"].round(2).to_s.colorize(:red)}" + "%".colorize(:red)
		end
		puts " "
		puts "Total Market Cap: $#{data["market_data"]["market_cap"]["usd"].to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse}"
		puts "#{data["description"]["en"]}"
		puts "==========================================="
		Market.menu
	end
end

