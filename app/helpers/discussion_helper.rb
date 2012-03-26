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
end
