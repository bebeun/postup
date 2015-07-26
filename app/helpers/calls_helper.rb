module CallsHelper
	def description_by_display(display)
		
		if (display.include? "facebook.com") || (display.include? "twitter.com" )
			if display.include? "facebook.com"
				return "category" => "Facebook", "description" => display.split('facebook.com')[1].split('/')[1]
			end
			if display.include? "twitter.com" 
				return "category" => "Twitter", "description" => display.split('twitter.com')[1].split('/')[1]
			end
		else
			return nil
		end
	end
end
