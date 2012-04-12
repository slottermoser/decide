module DecisionsHelper
  def event_server_url(rootUrl)
    base = rootUrl[0...-1]
    base_parts = base[6...-1].rpartition(':')
    # Check to see if we're running on a port other than 80
    if base_parts[1] == ":"
      base = base.rpartition(':')[0]
    end
    return base << ":8080"
  end
end
