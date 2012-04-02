module DiscussionHelper
  def event_server_url
    base = root_url[0...-1]
    base_parts = base.rpartition(':')
    # Check to see if we're running on a port other than 80
    if base_parts[1] == ":"
      base = base_parts[0]
    end
    return base << ":8080"
  end
end