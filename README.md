# Weather Forecast Application

Rails web application that provides weather forecasts using Open-Meteo API. The application features address search (e.g. city, zip etc) with autocomplete, and displays current weather conditions along with a 5-day forecast.

## Tech Stack
- **Frontend**: Hotwire (Turbo + Stimulus), Tailwind CSS
- **Backend**: Ruby on Rails 8
- **APIs**:
    - Open-Meteo for weather data
    - OpenMeteo Geocoding API for city search


    The application uses adapter pattern to abstract underlying API calls by impelementing service objects. As new geocoder or weather API clients get implemented (e.g google, openweather, weather.gov etc); they can be easily swapped out with minimal changes to the application. 
- **Testing**: Minitest

## Local Setup
```bash
# clone the repository
git clone <repository-url>
cd weather

# install dependencies and run the server
bundle install
rails db:create db:migrate
bin/dev

# running tests
rails test
```



## Configuration
Open-Meto doesn't require any api keys to make calls, so no configuration is required. 

As new providers are added, create a `.env` file in the root directory to manage API keys or environment variables.

## Deployment

The application is ready to be deployed to any ubuntu servers or any standard Rails hosting platform like Heroku, Render. 

Refer kamal deploy guide for more details.

