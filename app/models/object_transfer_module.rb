module ObjectTransferModule
	def transfer_up(call)
		#call.supporters.each{|y| self.supporters << y } and call.unsupporters.each{|y| self.unsupporters << y }
		call.object_actions.each{|oa|  oa.update_attributes(object: self) }
	end
end

