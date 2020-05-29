module Validations
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
        def is_numeric?(s)
        !!Float(s) rescue false
    end
end