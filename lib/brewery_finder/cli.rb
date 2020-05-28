class BreweryFinder::CLI
    def call
        input = nil
        until input == "exit"
        puts "Find Breweries in all 50 states and DC!"
        puts "Please enter your two-letter state abbreviation (including DC) or your 5 digit zipcode."
        puts "Type 'exit' at any time to exit."
        req = nil
        while req == nil do
            input = gets.chomp
            if input == "exit"
                exit
            end
            req = validate_zip_or_state(input)
        end
        breweries = list_breweries(req)
        index = nil
        while index == nil || index < 0 || index > breweries.length
            input = gets.chomp
            if is_numeric?(input)
                index = input.to_i - 1
            elsif input == "exit"
                exit
            else
                puts "Please enter a valid input."
            end
        end
        id = breweries[index]
        fetch_by_id(id)
        
        end
        #print_list
        puts "\nThank you for using brewery-finder!"
    end
    #fetches single brewery by ID
    def fetch_by_id(id)
        res = JSON.parse(open(URI_BASE + "/#{id}").read)
        puts ""
        puts res["name"]
        puts res["street"]
        puts "#{res['city']}, #{res['state']}"
        puts res["website_url"]
        puts ""
        puts "To save this brewery to your list, enter 'save'."
    end
    #uses get_breweries to format and list the breweries for the user
    def list_breweries(req)
        i = 1
        breweries = get_breweries(req)
        breweries_id = breweries.collect{|brewery| brewery['id']}
        breweries.each do |brewery|
            puts "#{i}. #{brewery['name']} - #{brewery['city']}"
            i+=1
        end
        puts "Enter a number between 1 and #{breweries.count} to select a brewery." 
        return breweries_id
    end
    #checks to see if string is made up of numbers
    def is_numeric?(s)
        !!Float(s) rescue false
    end
    #gets list of breweries for state or zipcode, after the input has been validated.
    def get_breweries(req)
        if is_numeric?(req)
            res = JSON.parse(open(URI_BASE + "?by_postal=#{req}").read)
        else
            res = JSON.parse(open(URI_BASE + "?by_state=#{req}").read)
        end
    end
    #checks if input is state or zip code
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