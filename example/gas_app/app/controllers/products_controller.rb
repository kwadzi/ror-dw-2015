class ProductsController < ApplicationController
  authorize_resource

  before_action :set_producer
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :require_login, except: [:index, :show]

  # GET /products
  # GET /products.json
  def index
    @products = @producer.products
  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = @producer.products.build
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    @product = @producer.products.build(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to producer_products_path(@producer), notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to producer_products_path(@producer), notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to producer_products_path(@producer), notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_producer
      @producer = Producer.find params[:producer_id]
    end

    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:name, :description, :price, :unit, :photo)
    end
end
