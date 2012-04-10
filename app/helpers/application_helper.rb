module ApplicationHelper

	def renderNavItems(activePage)
		htmlString = ""
		navigationItems = {
			"Decisions" => "/decisions",
			"Contact" => "/contact"
		}
		navigationItems.each do |item, route|
			if activePage == item
				htmlString << '<li class="active">'
			else
				htmlString << '<li>'
			end
			htmlString << '<a href="' <<  route << '">' << item << '</a></li>'
		end
		return htmlString
	end
end
