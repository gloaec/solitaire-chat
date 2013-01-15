class MessagesController < ApplicationController
  # GET /messages
  # GET /messages.json
  def index
    
    @messages = Message.all
    render json: @messages.map {|message| message.decrypt!(User.find(params[:user_id]).deck)}
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
    @message = Message.find(params[:id])
    @message.decrypt!(User.find(params[:user_id]).deck)
    
    #@deck = Deck.find(params[:id])

    render json: @message
  end

  # GET /messages/new
  # GET /messages/new.json
  def new
    @message = Message.new

    render json: @message
  end

  # POST /messages
  # POST /messages.json
  def create
    @message = Message.new(params[:message])
    @message.encrypt!
    #@deck = Deck.new(params[:deck])
    #@message.encrypt(@deck)
    
    if @message.save
      render json: @message.decrypt!, status: :created, location: @message
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /messages/1
  # PATCH/PUT /messages/1.json
  def update
    @message = Message.find(params[:id])

    if @message.update_attributes(params[:message])
      head :no_content
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message = Message.find(params[:id])
    @message.destroy

    head :no_content
  end

  # GET /highest_message_id.json
  def highest_id
    render json: Message.maximum(:id) || 0
  end  
end
