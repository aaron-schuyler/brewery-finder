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
                    exit
                elsif input == "list"
                    puts "Your list:\n"
                    Brewery.list.each do |brewery|
                        puts "\n#{brewery.name}"
                        puts brewery.address[:street]
                        puts "#{brewery.address[:city]}, #{brewery.address[:state]}"
                        puts brewery.url
                        puts "\n"
                    end
                    req = 1
                else
                    req = validate_zip_or_state(input)
                end
            end
            if req != nil || req != 1
                breweries = Api.new(req)
                breweries = breweries.fetch
                back = true
            end
            catch (:done) do
                if input == "list"
                    throw :done
                end
                while back == true 
                    i = 1
                    breweries.each do |brewery|
                        puts "#{i}. #{brewery.name} - #{brewery.address[:city]}" 
                        i+=1
                    end
                    index = nil
                    back = false
                    while index == nil || index < 0 || index > breweries.length
                        input = gets.chomp
                        if is_numeric?(input)
                            index = input.to_i - 1
                        elsif input == "exit"
                            exit
                        elsif input == ""
                            throw :done
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
                    puts "\nTo save to your list, type 'save'. To go back to the previous list, type 'back'. To enter a new state or zip press Enter, or type 'exit' to exit the program."
                    input = nil
                    while input == nil
                        input = gets.chomp
                        if input == "exit"
                            exit
                        elsif input == "save"
                            brewery.save
                            puts "Saved!"
                        elsif input == "back"
                            back = true
                        elsif input == ""
                            break
                        else
                            puts "please enter valid input"
                            input = nil
                        end
                        puts "\nTo go back to the previous list, type 'back'. To enter a new state or zip press Enter, or type 'exit' to exit the program."
                        input = gets.chomp
                        if input == "exit"
                            exit
                        elsif input == "back"
                            back = true
                        elsif input == ""
                            break
                        else
                            puts "please enter valid input"
                            input = nil
                        end
                    end
                end  
            end
        end 
    end
end