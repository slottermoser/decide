module DiscussionHelper
  def generate_entries(entries)
    results = []
    entries.each do |entry|
      children = generate_entries(entry.children)
      results << {
        :entry => entry,
        :children => children
      }
    end
    return results
  end
end
