module CallsHelper
	def description_by_display(display)
	
		@fb = Category.find_by(origin: "FB")
		@tw = Category.find_by(origin: "TW")
		
		if (display.include? "facebook.com") || (display.include? "twitter.com" )
			if display.include? "facebook.com"
				return "category" => @fb, "description" => display.split('facebook.com')[1].split('/')[1]
			end
			if display.include? "twitter.com" 
				return "category" => @tw, "description" => display.split('twitter.com')[1].split('/')[1]
			end
		else
			return nil
		end
	end
end
