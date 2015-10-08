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
	

	def add_profile_to(target_user, profile)
		source_user =  profile.owner
		
		#PotentialUser (source_user) s/u are transfered to target_user
		user_actions_sources = UserAction.where(supportable: source_user) 	
		user_actions_targets = UserAction.where(supportable: target_user)			
		user_actions_sources.each do |x|
			#if target_user had s/u source_user OR target_user was already s/u by someone who also s/u source_user (ie user_actions_targets rules!)
			if x.creator == target_user || user_actions_targets.collect{|y| y.creator}.include?(x.creator)
				x.destroy
			else
				x.update_attributes(supportable: target_user)
			end
		end
		
		#CALL where callable: PotentialUser
		destroy_calls = Call.where(callable: source_user)
		destroy_calls.each do |x| 
			if x.creator == target_user
				x.destroy
			else
				conversation = x.conversation
				futur_calls = conversation.calls.where(callable: target_user)
				case
					when !target_user.can_post?(conversation) && !target_user.can_call?(conversation)
						x.update_attributes(callable: target_user)
					when !target_user.can_post?(conversation) && target_user.can_call?(conversation)
						post = target_user.parent_call(conversation).child_post
						x.supporters.each do |y|
							post.supporters << y if !post.supporters.include?(y) && !post.unsupporters.include?(y)
						end
						x.unsupporters.each do |y|
							post.unsupporters << y if !post.supporters.include?(y) && !post.unsupporters.include?(y)
						end
						x.destroy
					when target_user.can_post?(conversation) 
						call = target_user.parent_call(conversation)
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
		target_user.add_profile(profile)
		source_user.destroy! if source_user.class.name == "PotentialUser"
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
