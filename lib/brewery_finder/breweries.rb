class Brewery
    extend Validations
   attr_accessor :id, :name, :address, :url
    @@all = []
    @@list = []
    def initialize(id, name, address, url)
        @id = id
       @name = name
        @address = address
        @url = url
        @@all << self
    end
    def self.all
        @@all
    end
    def self.list
        @@list
    end
    def self.find_by_id(id)
       @@all.find{|brewery| brewery.id == id} 
    end
    def self.find_or_create(brewery)
        id = brewery['id']
        name = brewery['name']
        address = {
            :street => brewery['street'],
            :city => brewery['city'],
            :state => brewery['state'],
            :zip => brewery['postal_code'].split("-")[0]
            }
        url = brewery['website_url']
        if find_by_id(id) == nil
            Brewery.new(id, name, address, url)
        else
            find_by_id(id)
        end
    end
    def self.list_by_state_or_zip(req)
        if is_numeric?(req)
            self.all.select{|brewery| brewery.address[:zip] == req}
        else
            self.all.select{|brewery| brewery.address[:state] == req}
        end
    end
    def save
        @@list << self
    end
end