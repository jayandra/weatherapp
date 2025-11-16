class SearchesController < ApplicationController
  # GET /searches/new
  def new
    @search = Search.new
  end

  # POST /searches or /searches.json
  def create
    # Returns cached forecasts if it exists, otherwise performs new API call and caches the results
    cache_key = "weather_forecasts_#{params[:search][:latitude]}_#{params[:search][:longitude]}"
    @cache_exists = Rails.cache.exist?(cache_key)
    @forecasts = Rails.cache.fetch(cache_key, expires_in: 30.minutes) do
      WeatherForecaster.new.perform(latitude: params[:search][:latitude], longitude: params[:search][:longitude], timezone: params[:search][:timezone])
    end

    @search = Search.new(search_params)
    respond_to do |format|
      if @search.save
        format.html { redirect_to new_search_path, notice: "Search was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
      format.turbo_stream
    end
  end

  # GET /searches/autocomplete?city=<city>
  def autocomplete
    # Returns cached results if it exists, otherwise performs a geocoder lookup and caches the results
    cache_key = "autocomplete_#{params[:city].parameterize}"
    results = Rails.cache.fetch(cache_key, expires_in: 1.week) do
      query = params[:city].to_s.strip
      Geocoder.new.perform(query)
    end

    render json: results.to_json
  end

  private
    # Only allow a list of trusted parameters through.
    def search_params
      params.expect(search: [ :city ])
    end
end
