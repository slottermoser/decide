class DecisionsController < ApplicationController
  before_filter :require_login
  
  private
  
  def require_login
    if current_user.nil?
      flash[:error] = "You must be signed in"
      redirect_to new_user_session_path
    end
  end
  
  public
  
  # GET /decisions
  # GET /decisions.json
  def index
    @decisions = current_user.created_decisions
    @participating = current_user.participating_decisions

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @decisions }
    end
  end

  # GET /decisions/1
  # GET /decisions/1.json
  def show
    @decision = Decision.find(params[:id])
    @choices = @decision.choices
    @discussion = @decision.discussion
    @my_id = current_user.id

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @decision}
    end
  end

  # GET /decisions/new
  # GET /decisions/new.json
  def new
    @decision = Decision.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @decision }
    end
  end

  # GET /decisions/1/edit
  def edit
    @decision = Decision.find(params[:id])
  end

  # POST /decisions
  # POST /decisions.json
  def create
    @decision = Decision.new(params[:decision])
    logger.info "----------------"
    logger.info params
    logger.info "----------------"
    @decision.creator = current_user

    respond_to do |format|
      if @decision.save
        #save choices
        if params[:choice1] && params[:choice1] != ""
          choice1 = @decision.choices.build
          choice1.title = params[:choice1]
          choice1.save
        end
        if params[:choice2] && params[:choice2] != ""
          choice1 = @decision.choices.build
          choice1.title = params[:choice2]
          choice1.save
        end
        if params[:choice3] && params[:choice3] != ""
          choice1 = @decision.choices.build
          choice1.title = params[:choice3]
          choice1.save
        end
        if params[:choice4] && params[:choice4] != ""
          choice1 = @decision.choices.build
          choice1.title = params[:choice4]
          choice1.save
        end

        discussion = Discussion.new
        @decision.discussion = discussion
        @decision.participants = User.all
        discussion.save
        format.html { redirect_to @decision, notice: 'Decision was successfully created.' }
        format.json { render json: @decision, status: :created, location: @decision }
      else
        format.html { render action: "new" }
        format.json { render json: @decision.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /decisions/1
  # PUT /decisions/1.json
  def update
    @decision = Decision.find(params[:id])

    respond_to do |format|
      if @decision.update_attributes(params[:decision])
        format.html { redirect_to @decision, notice: 'Decision was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @decision.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /decisions/1
  # DELETE /decisions/1.json
  def destroy
    @decision = Decision.find(params[:id])
    @decision.destroy

    respond_to do |format|
      format.html { redirect_to decisions_url }
      format.json { head :no_content }
    end
  end
end
