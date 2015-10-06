module ProfilesHelper
	def description_by_display(display)
		profile = nil
		Profile::PROFILE_TYPES.each do |x|
			profile = Profile.build_with(x, display) if Profile.is_it?(x,display)
			#check for priority
		end
		profile.owner ||= PotentialUser.new()  if !profile.nil? 
		return profile
	end
	

	def add_profile_to(creator, profile)
		user_destroy =  profile.owner
		
		#PotentialUser (user_destroy) s/u are transfered to creator
		user_actions_slaves = UserAction.where(supportable: user_destroy) 	
		user_actions_masters = UserAction.where(supportable: creator)			
		user_actions_slaves.each do |x|
			#if creator had s/u user_destroy OR creator was already s/u by someone who also s/u user_destroy (ie user_actions_masters rules!)
			if x.creator == creator || user_actions_masters.collect{|y| y.creator}.include?(x.creator)
				x.destroy
			else
				x.update_attributes(supportable: creator)
			end
		end
		
		#CALL where callable: PotentialUser
		destroy_calls = Call.where(callable: user_destroy)
		destroy_calls.each do |x| 
			if x.creator == creator
				x.destroy
			else
				conversation = x.conversation
				futur_calls = conversation.calls.where(callable: creator)
				case
					when !creator.can_post?(conversation) && !creator.can_call?(conversation)
						x.update_attributes(callable: creator)
					when !creator.can_post?(conversation) && creator.can_call?(conversation)
						post = creator.parent_call(conversation).child_post
						x.supporters.each do |y|
							post.supporters << y if !post.supporters.include?(y) && !post.unsupporters.include?(y)
						end
						x.unsupporters.each do |y|
							post.unsupporters << y if !post.supporters.include?(y) && !post.unsupporters.include?(y)
						end
						x.destroy
					when creator.can_post?(conversation) 
						call = creator.parent_call(conversation)
						x.supporters.each do |y|
							call.supporters << y if !call.supporters.include?(y) && !call.unsupporters.include?(y) && call.callable != y 
						end
						x.unsupporters.each do |y|
							call.unsupporters << y if !call.supporters.include?(y) && !call.unsupporters.include?(y) && call.callable != y 
						end
						x.destroy
				end
			end
		end
		
		creator.add_profile(profile)
		user_destroy.destroy! if user_destroy.class.name == "PotentialUser"
	end
	
	def get_profile_global_id(profile)
		global_id = Profile::PROFILE_TYPES.count*profile.id.to_i + Profile::PROFILE_TYPES.index(profile.class.name)
		return global_id
	end
	
	def get_profile(global_id)
		global_id = global_id.to_i
		classname = Profile::PROFILE_TYPES[global_id%Profile::PROFILE_TYPES.count]
		profile = classname.constantize.find((global_id-global_id%Profile::PROFILE_TYPES.count)/Profile::PROFILE_TYPES.count)
		return profile
	end
end
