module ObjectTransferModule
	def transfer_down
		self.transfer("down")
	end
	
	def transfer_up
		self.transfer("up")
	end

	def transfer(way)
		case
		when self.class.name == "Call"
			if !self.brother_aftf.nil?
				source = self.brother_aftf and target = self if way == "up"
				source = self and target = self.brother_aftf if way == "down"
				if way == "up"
					source.supporters.each{|y| target.supporters << y if !target.supporters.include?(y) && !target.unsupporters.include?(y)}
					source.unsupporters.each{|y| target.unsupporters << y if !target.supporters.include?(y) && !target.unsupporters.include?(y)}
				end	
				if way == "down"
					source.supporters.each{|y| target.supporters << y if !target.supporters.include?(y) && !target.unsupporters.include?(y) && y != source.creator}
					source.unsupporters.each{|y| target.unsupporters << y if !target.supporters.include?(y) && !target.unsupporters.include?(y) }
				end	
			end
				
		when self.class.name == "Post"
			if parent_type == "Call"
				source = self.parent and target = self if way == "up"
				source = self and target = self.parent if way == "down"
				if way == "up"
					source.supporters.each{|y| target.supporters << y if !target.supporters.include?(y) && !target.unsupporters.include?(y)}
					source.unsupporters.each{|y| target.unsupporters << y if !target.supporters.include?(y) && !target.unsupporters.include?(y)}
				end	
			end
		end
	end
end

