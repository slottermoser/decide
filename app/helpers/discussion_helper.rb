module DiscussionHelper
  def generate_entries(entries)
    results = []
    entries.each do |entry|
      children = generate_entries(entry.children)
      entry_info = {
        name:entry.user.name,
        created_at:entry.created_at.strftime('%m/%d/%Y %H:%M'),
        entry:entry.entry,
        id:entry.id
      }
      results << {
        :entry => entry_info,
        :children => children
      }
    end
    return results
  end

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
