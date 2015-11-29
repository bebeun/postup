module UserObjectsModule
	def objects_for_user(user, current_user)
		case	
			when user.class.name == "User"
				objects = ObjectAction.select{|oa| oa.status == "active" && oa.creator == user && oa.object.creator != user}
				objects += user.callins.select{|call| call.status == "active" && !call.declined && call.post.nil?} 
				objects += user.callouts.select{|call| call.post.nil? && (call.supporters.include?(user) || call.supporters.include?(user))}#ré écrire callouts !!!
				objects += user.posts.select{|post| post.status == "active" && (post.supporters.include?(user) || post.supporters.include?(user))} 
			when user.class.name == "PotentialUser"
				objects = user.callins
		end
	return objects.sort_by{ |obj| obj.created_at}
	end
end