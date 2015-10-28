class UsersController < ApplicationController
	def show
		@user = User.find(params[:id]) 
		aftfs_asked = @user.aftfs
		aftfs_answered = Aftf.select{|x| x.decider == @user}
		aftfs_supported = Aftf.select { |w| ((w.supporters.include?(@user) || w.unsupporters.include?(@user)) && w.creator != @user &&  w.decider != @user)}
		callins = @user.callins
		callouts = @user.callouts
		callssupported = Call.select { |w| ((w.supporters.include?(@user) || w.unsupporters.include?(@user)) && w.creator != @user)}
		posts_created = Post.select{ |x| x.creator == @user }
		posts_supported = Post.select { |w| ((w.supporters.include?(@user) || w.unsupporters.include?(@user)) && w.creator != @user)}
		
		@objects = aftfs_asked + aftfs_answered + aftfs_supported + callins + callouts + callssupported + posts_created + posts_supported
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

end
