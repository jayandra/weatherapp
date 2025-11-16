class SearchesController < ApplicationController
  before_action :set_search, only: %i[ show edit update destroy ]

  # GET /searches or /searches.json
  def index
    @searches = Search.all
  end

  # GET /searches/1 or /searches/1.json
  def show
  end

  # GET /searches/new
  def new
    @search = Search.new
  end

  # GET /searches/1/edit
  def edit
  end

  # POST /searches or /searches.json
  def create
    @search = Search.new(search_params)
    @forecasts = WeatherForecaster.new.perform(latitude: params[:search][:latitude], longitude: params[:search][:longitude], timezone: params[:search][:timezone])

    respond_to do |format|
      if @search.save
        format.html { redirect_to @search, notice: "Search was successfully created." }
        format.json { render :show, status: :created, location: @search }
        format.turbo_stream
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @search.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /searches/1 or /searches/1.json
  def update
    respond_to do |format|
      if @search.update(search_params)
        format.html { redirect_to @search, notice: "Search was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @search }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @search.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /searches/1 or /searches/1.json
  def destroy
    @search.destroy!

    respond_to do |format|
      format.html { redirect_to searches_path, notice: "Search was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  # GET /searches/autocomplete?city=
  def autocomplete
    query = params[:city]
    results = Geocoder.new.perform(query)
    render json: results.to_json
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_search
      @search = Search.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def search_params
      params.expect(search: [ :city ])
    end
end
