class ProducersController < ApplicationController
  authorize_resource

  before_action :set_producer, only: [:show, :edit, :update, :destroy]
  before_action :not_logged_in, only: [:new, :create]
  before_action :require_login, only: [:edit, :update, :destroy]

  # GET /producers
  # GET /producers.json
  def index
    @producers = Producer.all
  end

  # GET /producers/1
  # GET /producers/1.json
  def show
  end

  def map
    @markers = Gmaps4rails.build_markers(Producer.all) do |producer, marker|
      marker.lat producer.latitude
      marker.lng producer.longitude
    end
  end

  # GET /producers/new
  def new
    @producer = Producer.new
  end

  # GET /producers/1/edit
  def edit
  end

  # POST /producers
  # POST /producers.json
  def create
    @producer = Producer.new(producer_params)

    respond_to do |format|
      if @producer.save
        format.html { redirect_to @producer, notice: 'Producer was successfully created.' }
        format.json { render :show, status: :created, location: @producer }
      else
        format.html { render :new }
        format.json { render json: @producer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /producers/1
  # PATCH/PUT /producers/1.json
  def update
    respond_to do |format|
      if @producer.update(producer_params)
        format.html { redirect_to @producer, notice: 'Producer was successfully updated.' }
        format.json { render :show, status: :ok, location: @producer }
      else
        format.html { render :edit }
        format.json { render json: @producer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /producers/1
  # DELETE /producers/1.json
  def destroy
    @producer.destroy
    respond_to do |format|
      format.html { redirect_to producers_url, notice: 'Producer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_producer
      @producer = Producer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def producer_params
      params.require(:producer).permit(:name, :address, :email, :phone, :password, :password_confirmation)
    end

    def not_logged_in
      if logged_in?
        flash[:error] = "Access denied"
        redirect_to root_path
        return false
      end
    end
end
