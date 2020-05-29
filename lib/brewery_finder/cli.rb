class BreweryFinder::CLI
    include Validations
    def call
        input = nil
        until input == "exit"
            puts "Find Breweries in all 50 states and DC!"
            puts "Please enter your two-letter state abbreviation (including DC) or your 5 digit zipcode."
            puts "Type 'list' to display your list. Type 'exit' at any time to exit."
            req = nil
            while req == nil do
                input = gets.chomp
                if input == "exit"
                    Brewery.print_breweries
                    puts "\nThank you for using brewery-finder!"
                    exit
                end
                req = validate_zip_or_state(input)
            end
            breweries = Api.new(req)
            breweries = breweries.fetch
            i = 1
            breweries.each do |brewery|
               puts "#{i}. #{brewery.name} - #{brewery.address[:city]}" 
                i+=1
            end
            index = nil
            while index == nil || index < 0 || index > breweries.length
                input = gets.chomp
                if is_numeric?(input)
                    index = input.to_i - 1
                elsif input == "exit"
                    Brewery.print_breweries
                    exit
                else
                    puts "Please enter a valid input."
                end
            end
            id = breweries[index].id
            brewery = Brewery.find_by_id(id)
            puts brewery.name
            puts brewery.address[:street]
            puts brewery.address[:city] + ", " + brewery.address[:state]
            puts brewery.url

        end
        Brewery.print_breweries
        puts "\nThank you for using brewery-finder!"
    end
end