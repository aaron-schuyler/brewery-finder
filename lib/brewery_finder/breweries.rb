class Brewery
   attr_accessor :name, :address, :url
    @@all = []
    def initialize(name, address, url)
       @name = name
        @address = address
        @url = url
        @@all << self
    end
    def self.all
        @@all
    end
    def self.print_breweries
       Brewery.all.each do |brewery|
           puts brewery.name
           puts brewery.address[:street]
           puts "#{brewery.address[:city]}, #{brewery.address[:state]}\n"
       end
    end
end