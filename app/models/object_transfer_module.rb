module ObjectTransferModule
	def transfer_up(call)
		call.supporters.each{|y| self.supporters << y } and call.unsupporters.each{|y| self.unsupporters << y }
	end
end

