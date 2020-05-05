
class GeckoScraper::Controller

	def call
		extend Repeatable
		name = "GeckoScraper"
		welcome = "Welcome to the #{name.colorize(:green)} cryptocurrency data scraper!"
		puts welcome

		Market.menu
		
	end
	
end