module ObjectTransferModule
	def transfer_down
		self.transfer("down")
	end
	
	def transfer_post_up
		self.transfer("up")
	end

	def transfer(way)
		case
		
			when self.class.name == "Call"
				if !self.authorised_aftf.nil?
					source = self.authorised_aftf and target = self if way == "up"
					source = self and target = self.authorised_aftf if way == "down"
					source.supporters.each{|y| target.supporters << y if (!target.supporters.include?(y) && !target.unsupporters.include?(y))}
					source.unsupporters.each{|y| target.unsupporters << y if (!target.supporters.include?(y) && !target.unsupporters.include?(y))} 
					ObjectAction.where(object: source).destroy_all
					self.creator.remove(target) if way == "down"  #retouver l'ancien feeling du call.creator sur l'aftf ?
				end
				
			when self.class.name == "Post"
				if parent_type == "Call"
					source = self.parent and target = self if way == "up"
					source = self and target = self.parent if way == "down"
					source.supporters.each{|y| target.supporters << y if (!target.supporters.include?(y) && !target.unsupporters.include?(y))}
					source.unsupporters.each{|y| target.unsupporters << y if (!target.supporters.include?(y) && !target.unsupporters.include?(y))} 
					#post détruit et down => ne pas garder le s/u spécifiques au post ??
					ObjectAction.where(object: source).destroy_all
					if way == "down"
						target.creator.supports(target) 
						(!target.authorised_aftf.nil? ) ? (target.callable.supports(target)) : (target.callable.remove(target))
					end		
					
				end
		end
	end
end