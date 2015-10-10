module ObjectTransfer
	def transfer_call_s_u_up
		if !authorised_aftf.nil?
			authorised_aftf.supporters.each{|y| supporters << y if (!supporters.include?(y) && !unsupporters.include?(y))}
			authorised_aftf.unsupporters.each{|y| unsupporters << y if (!supporters.include?(y) && !unsupporters.include?(y))} 
			ObjectAction.where(object: authorised_aftf).destroy_all
		end
	end	
	
	def transfer_call_s_u_down
		if !authorised_aftf.nil?
			supporters.each{|y| authorised_aftf.supporters << y if (!authorised_aftf.supporters.include?(y) && !authorised_aftf.unsupporters.include?(y))}
			unsupporters.each{|y| authorised_aftf.unsupporters << y if (!authorised_aftf.supporters.include?(y) && !authorised_aftf.unsupporters.include?(y))} 
			ObjectAction.where(object: self).destroy_all			
			creator.remove(authorised_aftf)
		end
	end
	
	def transfer_post_s_u_up
		if parent_type == "Call"
			parent.supporters.each{|y| supporters << y if (!supporters.include?(y) && !unsupporters.include?(y))}
			parent.unsupporters.each{|y| unsupporters << y if (!supporters.include?(y) && !unsupporters.include?(y))} 
			ObjectAction.where(object: parent).destroy_all
		end
	end
	
	def transfer_post_s_u_down
		if parent_type == "Call"
			supporters.each{|y| parent.supporters << y if (!parent.supporters.include?(y) && !parent.unsupporters.include?(y))}
			unsupporters.each{|y| parent.unsupporters << y if (!parent.supporters.include?(y) && !parent.unsupporters.include?(y))} 
			ObjectAction.where(object: self).destroy_all
			parent.creator.supports(parent) 
			(!parent.authorised_aftf.nil? ) ? (parent.callable.supports(parent)) : (parent.callable.remove(parent))
		end
	end
end