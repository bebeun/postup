module SupportModule
	def s
		return ss + uu
	end
	
	def u
		return us + su
	end
	
	def ss
		return self.supporters.collect{ |user| (user.supporters - [self]).count}.sum
	end
	
	def su
		return self.supporters.collect{ |user| (user.unsupporters - [self]).count}.sum
	end
	
	def uu
		return self.unsupporters.collect{ |user| (user.unsupporters - [self]).count}.sum
	end
	
	def us
		return self.unsupporters.collect{ |user| (user.supporters - [self]).count}.sum
	end
end

