module UserObjectsModule
	def objects_for_user(user, current_user)
		case	
			when user.class.name == "User"
			 
				#S/U sur des Posts dont user n'est pas l'auteur
				objects = ObjectAction.select{|oa| oa.object_type == "Post"}.select{|oa| oa.status == "active" && oa.creator == user && oa.object.creator != user }

				#S/U sur des Calls non répondus
				objects += ObjectAction.select{|oa| oa.object_type == "Call"}.select{|oa| oa.status == "active" && oa.creator == user && oa.object.post.nil? }

				#Callins actifs, non déclinés et non répondus
				objects += user.callins.select{|call| call.status == "active" && !call.declined && call.post.nil?}
				
				#Posts dont user est l'auteur et qu'il S encore
				objects += user.posts.select{|post| post.supporters.include?(user)}
			
			when user.class.name == "PotentialUser"
				objects = user.callins.select{|call| call.status == "active" }
		end

	return objects.sort_by{ |obj| obj.created_at}
	end
end