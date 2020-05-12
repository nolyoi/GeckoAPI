# Base API URI. Append coin name for individual details.
# https://api.coingecko.com/api/v3/coins/
#
# Append for marketcap
# markets?vs_currency=usd

class Market
  attr_accessor :id, :name, :symbol, :price, :description, :market_cap, :percent_change, :algo, :github, :website, :block_time, :block_explorer, :api_address, :price_movement_24h, :market_cap_rank, :image
  BASE_URL = - 'https://api.coingecko.com/api/v3/coins/'
  @@market = []

  def initialize(coin)
    @id = coin['id']
    @name = coin['name']
    @symbol = coin['symbol']
    @image = coin['image']
    @price = coin['current_price'].to_s
    @price_movement_24h = coin['price_change_percentage_24h']
    @market_cap = coin['market_cap'].to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
    @market_cap_rank = coin['market_cap_rank']
    @api_address = "#{BASE_URL}#{coin['id']}"
    @description = nil
    @github = nil
    @website = nil
    @algo = nil
    @block_time = nil
    @block_explorer = nil
    @percent_change = nil
    @@market << self
  end

  def self.all
    @@market
  end

  def self.get_market
    data = JSON.parse(open(BASE_URL + 'markets?vs_currency=usd').read)

    data.each do |coin|
      Market.new(coin)
    end
  end

  def coin_data
    data = JSON.parse(open(api_address).read)
    @description = data['description']['en'].gsub(/<[^"\\] href="/, '(').gsub(/["\\]>/, ') ').gsub(/<[^<\\]a>/, '')
    @github = data['links']['repos_url']['github'][0]
    @website = data['links']['homepage'][0]
    @algo = data['hashing_algorithm']
    @block_time = data['links']['blockchain_site'][0]
    @block_explorer = data['block_time_in_minutes']
    @percent_change = data['market_data']['price_change_percentage_24h']
  end

  def self.update
    @@marker = []
    Market.get_market
  end

  def self.top
    rows = [] # rows for terminal-table

    @@market.each do |coin|
      if coin.price_movement_24h.to_i > 0
        rows << [coin.market_cap_rank, coin.name, coin.symbol.upcase, "$#{coin.price.colorize(:green)}"]
      else
        rows << [coin.market_cap_rank, coin.name, coin.symbol.upcase, "$#{coin.price.colorize(:red)}"]
      end
    end

    table = Terminal::Table.new headings: ['Rank', 'Name', 'Symbol', 'Current Price'], rows: rows
    puts table
  end

  def self.coin_info(input)
    @@market.each do |coin|
      if coin.market_cap_rank == input.to_i
        coin.coin_data
      else
        print '.'
      end
    end
    Controller.clear_term
  end
end
