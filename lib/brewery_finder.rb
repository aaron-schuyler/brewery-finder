require 'open-uri'
require 'json'
require_relative "brewery_finder/version"
require_relative "concerns/validations"
require_relative "./brewery_finder/cli"
require_relative "./brewery_finder/breweries"
require_relative "./brewery_finder/api"
URI_BASE = "https://api.openbrewerydb.org/breweries"
STATE_URI = "https://openstates.org/api/v1/metadata/"
STATE_APIKEY = "ff4725d7-8004-45d0-9baa-c369e4d4bbf5"
