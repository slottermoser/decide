class DiscussionController < ApplicationController
  def show
  end

  def get_entries
  end
  
  def new_comment
    discussion = Discussion.find(params[:id])
    new_comment = DiscussionEntry.new({:entry => params["text"]})
    new_comment.discussion = discussion
    # new_comment.user = current_user
    
    if new_comment.save
      render :json => {:status => "success", :entry_info => {:entry => new_comment, :children => []}}
    else
      render :json => {:status => "error", :message => "Could not save reply"}
    end
    
  end

  def add_reply
    parent_entry = DiscussionEntry.find(params[:id])
    new_entry = DiscussionEntry.new({:entry => params['text']})
    new_entry.parent = parent_entry
    new_entry.discussion = parent_entry.discussion
    # new_entry.user = current_user
    
    if new_entry.save
      render :json => {:status => "success", :entry_info => {:entry => new_entry, :children => []}}
    else
      render :json => {:status => "error", :message => "Could not save reply"}
    end
    
  end
end
