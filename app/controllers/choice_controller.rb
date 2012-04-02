class ChoiceController < ApplicationController
  before_filter :require_login
  
  private
  
  def require_login
    if current_user.nil?
      flash[:error] = "You must be signed in"
      redirect_to new_user_session_path
    end
  end
  
  public

  # Renders partial for decision.html
  def show
  end

  # POST /decisions/1/choices/new.json
  def new
    @decision = Decision.find(params[:decision_id])
    return unless @decision
    @choice = @decision.choices.create

    respond_to do |format|
      format.json { render json: @choice }
    end
  end

  # POST /choices.json
  def create
    @choice = Choice.new(params[:choice])
    @choice.creator = current_user

    respond_to do |format|
      if @choice.save
        format.json { render json: @choice, status: :created, location: @choice }
      else
        format.json { render json: @choice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /choices/1.json
  def update
    @choice = Choice.find(params[:id])

    respond_to do |format|
      if @choice.update_attributes(params[:choice])
        format.json { head :no_content }
      else
        format.json { render json: @choice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /choices/1.json
  def destroy
    @choice = Choice.find(params[:id])
    @choice.destroy

    respond_to do |format|
      format.json { head :no_content }
    end
  end

end
