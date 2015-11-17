class UsersController < ApplicationController
	def show
		@user = User.find(params[:id]) 
		oa = ObjectAction.select{|oa| !oa.swept && oa.creator == current_user && !(oa.object.class.name == "Post" && oa.object.creator == @user) && !(oa.object.class.name == "Call" && oa.object.creator == @user)}
		objects = oa + @user.callins.select{|call| !call.swept} + @user.posts.select{|post| !post.swept} + @user.callouts.select{|call| call.supporters.include?(current_user) || call.supporters.include?(current_user)}
		@objects = objects.sort_by{ |obj| obj.created_at}
	end
	
	def support
		user = User.find(params[:id]) 
		#@user.supporters << current_user
		user_action = UserAction.find_or_initialize_by(creator: current_user, supportable: user)
		user_action.update_attributes(:support => "up")
		user_action.save!
		redirect_to user
	end
	
	def unsupport
		user = User.find(params[:id]) 
		user_action = UserAction.find_or_initialize_by(creator: current_user, supportable: user)
		user_action.update_attributes(:support => "down")
		user_action.save!
		redirect_to user
	end
	
	def remove_support
		user = User.find(params[:id]) 
		user_action = UserAction.find_by(creator: current_user, supportable: user)
		user_action.destroy
		redirect_to user
	end
	
	def sweep_until
		ObjectAction.where(creator: current_user).select{|oa| oa.created_at <= params[:time_limit].to_time  + 1.second}.each do |oa|
			oa.update_attributes(swept: true) 
		end
		Call.where(callable: current_user).select{|call| call.created_at <= params[:time_limit].to_time  + 1.second}.each{|call| call.update_attributes(swept: true)}
		Post.where(creator: current_user).select{|post| post.created_at <= params[:time_limit].to_time  + 1.second}.each{|post| post.update_attributes(swept: true)}
		redirect_to :back
	end

end
