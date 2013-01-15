class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  def index
    @users = User.all
    #@users.each {|user| user.deck = Marshal.load(Base64.decode64(user.deck)) }
    render json: @users
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    #@user.deck = Marshal.load(@user.deck)
    #@user.deck = Marshal.load(Base64.decode64(@user.deck))
    @user.deck = JSON.parse(@user.deck.to_json)
    render json: @user
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new
    @user.deck = JSON.parse(Deck.new.to_json)
    render json: @user
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])
    @user.deck = Deck.new
    if @user.save
      @user.deck = JSON.parse(@user.deck.to_json)
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    @user = User.find(params[:id])
    params[:user][:deck] = Deck.new.loadJSON(params[:user][:deck])
    
    if @user.update_attributes(params[:user])
      @user.deck = JSON.parse(@user.deck.to_json)
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    head :no_content
  end

  # GET /highest_user_id.json
  def highest_id
    render json: User.maximum(:id) || 0
  end  
  
  def shuffle
    @user = User.find(params[:id])
    @user.deck.shuffle!
    if @user.save
      @user.deck = JSON.parse(@user.deck.to_json)
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end
  
  def new_deck
    @user = User.find(params[:id])
    @user.deck = Deck.new
    if @user.save
      @user.deck = JSON.parse(@user.deck.to_json)
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end
end
