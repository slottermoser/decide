class VoteController < ApplicationController
  before_filter :require_login
  
  private
  
  def require_login
    if current_user.nil?
      flash[:error] = "You must be signed in"
      redirect_to new_user_session_path
    end
  end
  
  public
  # POST /choices/1/vote.json
  def create
    @choice = Choice.find(params[:choice_id])
    @vote = @choice.votes.build
    @vote.voter = current_user

    if @vote.save
      @choice.vote_count += 1
      @choice.save
      render :json => {vote: @vote, status: "success"}, status: :created
    else
      render :json => {errors:@vote.errors, status: "error"}, status: :unprocessable_entity
    end
  end

  # DELETE /choices/1/delete_vote.json
  def destroy
    @vote = Vote.find_by_voter_and_choice_id(current_user.id, params[:choice_id])

    if @vote && @vote.destroy
      @choice = Choice.find(params[:choice_id])
      @choice.vote_count -= 1
      @choice.save
      render :json => {vote: @vote, status: "success"}
    else
      render :json => {:error => "Delete failed", status: "error"}, :status => :bad_request
    end
  end
end
