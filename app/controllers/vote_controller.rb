class VoteController < ApplicationController

  # POST /choices/1/vote.json
  def create
    @choice = Choice.find(params[:choice_id])
    @vote = @choice.votes.build
    @vote.voter = current_user

    if @vote.save
      @choice.vote_count += 1
      @choice.save
      render json: @vote, status: :created
    else
      render json: @vote.errors, status: :unprocessable_entity
    end
  end

  # DELETE /choices/1/delete_vote.json
  def destroy
    @vote = Vote.find_by_voter_and_choice_id(current_user.id, params[:choice_id])

    if @vote && @vote.destroy
      @choice = Choice.find(params[:choice_id])
      @choice.vote_count -= 1
      @choice.save
      render :json => @vote
    else
      render :json => {:error => "Delete failed"}, :status => :bad_request
    end
  end
end
