class BreweryFinder::CLI
   def call
       puts "Find Breweries in all 50 states and DC!"
       puts "Please enter your two-letter state abbreviation(including DC) or your 5 digit zipcode."
       req = nil
       while req == nil do
          input = gets.chomp
          req = validate_zip_or_state(input)
       end
       list_breweries(req)
   end
    
    def list_breweries(req)
       i = 1
       breweries = get_breweries(req)
            breweries.each do |brewery|
           puts "#{i}. #{brewery['name']} - #{brewery['city']}"
           i+=1
       end
       puts "Enter a number between 1 and #{breweries.count} to select a brewery." 
    end
    def is_numeric?(s)
        !!Float(s) rescue false
    end
    
    def get_breweries(req)
        if is_numeric?(req)
           res = JSON.parse(open(URI_BASE + "?by_postal=#{req}").read)
       else
           res = JSON.parse(open(URI_BASE + "?by_state=#{req}").read)
       end
    end
    
    def validate_zip_or_state(input)
         if is_numeric?(input) && input.length == 5
               zip = input
             return zip
           elsif input.length == 2 && input.class == String
               begin
                    res = open(STATE_URI + input.downcase + "?apikey=" + STATE_APIKEY).read
               rescue
                   puts "please enter a valid state"
               end
               if res != nil
                    state = JSON.parse(res)["name"]
                   return state
               end
           else
               puts "please enter valid input"
             return nil
           end
    end
end