class Api 
    include Validations
    attr_accessor :url, :zip, :state
    def initialize(req)
        if is_numeric?(req)
            @url = URI_BASE + "?by_postal=#{req}"
            @zip = req
        else
            @url = URI_BASE + "?by_state=#{req}"
            @state = req
        end
    end
    def fetch
        res = JSON.parse(open(@url).read)
        res.each do |brewery|
            Brewery.find_or_create(brewery)
        end
        if @zip != nil
            req = @zip
        else
            req = @state
        end
        Brewery.list_by_state_or_zip(req)
    end
end