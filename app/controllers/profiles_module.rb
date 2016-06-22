module ProfilesModule
	def description_by_display(display)
		profile = nil
		Profile::PROFILE_TYPES.each do |x|
			result = /#{Profile::PROFILE_REGEXP[x]}/.match(display)
			if result
				profile = x.constantize.find_or_initialize_by(description: result["description"])
				break
			end
			#check for priority
		end
		profile.owner ||= PotentialUser.new()  if !profile.nil? 
		return profile
	end
	

	def add_profile_to(target_user, profile)
		source_user =  profile.owner # source_user == PotentialUser
		
		
#=======> Call.where(callable: source_user)...
		destroy_calls = Call.where(callable: source_user)
		destroy_calls.each do |call| 
#==============RECTIFICATION CALL.CREATOR
			ObjectAction.where(creator: target_user, object: call).destroy_all

			if !ObjectAction.where(object: call)
				call.destroy 
				p "===============================destruction !!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
			else
				if !call.conversation.calls.where(callable: target_user).any?
					call.update_attributes(callable: target_user)
				else
					last_call = call.conversation.calls.where(callable: target_user).last
					call.object_actions.each do |oa| 
						oa.update_attributes(object: last_call) if ObjectAction.find_by(object: last_call, creator: oa.creator).nil?
					end
					call.destroy
				end
			end
		end

		profile.update_attributes(owner: target_user)
		source_user.destroy! if source_user.class.name == "PotentialUser"
	end
end
