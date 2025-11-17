## Weather Forecast Application

Rails web application that provides weather forecasts for any address in the world.
- Supports address search (e.g., city, ZIP code) with autocomplete suggestions.
- Displays current temperatures along with a 5-day forecast.
- Implements caching for improved performance (indicates when data is served from cache).

The app has been deployed at https://weatherapp-ahk2.onrender.com. As it is on a free tier, the initial start up might take a few minutes.

## Tech Stack
- **Frontend**: Hotwire (Turbo + Stimulus), Tailwind CSS
- **Backend**: Ruby on Rails 8
- **APIs**:
    - Open-Meteo for weather data
    - OpenMeteo Geocoding API for city search


- **Testing**: Minitest
    
    The application uses adapter pattern to abstract API calls through service objects. This allows for seamless integration of additional geocoding or weather API clients (e.g., Google, OpenWeather, Weather.gov) with minimal code changes.

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

