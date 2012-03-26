class DiscussionController < ApplicationController
  def show
  end

  def get_entries
  end
  
  def new_comment
    discussion = Discussion.find(params[:id])
    new_comment = DiscussionEntry.new({:entry => params["text"]})
    new_comment.discussion = discussion
    new_comment.user = current_user
    
    if new_comment.save
      entry_info = {
        name:new_comment.user.name,
        created_at:new_comment.created_at.strftime('%m/%d/%Y %H:%M'),
        entry:new_comment.entry,
        id:new_comment.id
      }
      render :json => {:status => "success", :entry_info => {:entry => entry_info, :children => []}}
    else
      render :json => {:status => "error", :message => "Could not save reply"}
    end
    
  end

  def add_reply
    parent_entry = DiscussionEntry.find(params[:id])
    new_entry = DiscussionEntry.new({:entry => params['text']})
    new_entry.parent = parent_entry
    new_entry.discussion = parent_entry.discussion
    new_entry.user = current_user
    if new_entry.save
      entry_info = {
        name:new_entry.user.name,
        created_at:new_entry.created_at.strftime('%m/%d/%Y %H:%M'),
        entry:entry.new_entry,
        id:new_entry.id
      }
      render :json => {:status => "success", :entry_info => {:entry => entry_info, :children => []}}
    else
      render :json => {:status => "error", :message => "Could not save reply"}
    end
    
  end
end
