class UsersController < ApplicationController
	def show
		@user = User.find(params[:id]) 
		@postscreated = Post.where(creator: @user)
		@postssupported = Post.select { |w| (w.supporters.include?(@user) || w.unsupporters.include?(@user))}
		@callins = @user.callins
		@callouts = @user.callouts
		@callssupported = Call.select { |w| (w.supporters.include?(@user) || w.unsupporters.include?(@user))}
		
		@conversations = @postscreated.collect{|x| x.conversation } + @postssupported.collect{|x| x.conversation } + @callins.collect{|x| x.conversation } + @callouts.collect{|x| x.conversation } + @callssupported.collect{|x| x.conversation }
	end
	
	def support
		user = User.find(params[:id]) 
		#@user.supporters << current_user
		user_action = UserAction.find_or_initialize_by(user: current_user, supportable: user)
		user_action.update_attributes(:support => "up")
		user_action.save!
		redirect_to user
	end
	
	def unsupport
		user = User.find(params[:id]) 
		user_action = UserAction.find_or_initialize_by(user: current_user, supportable: user)
		user_action.update_attributes(:support => "down")
		user_action.save!
		redirect_to user
	end
	
	def remove_support
		user = User.find(params[:id]) 
		user_action = UserAction.find_by(user: current_user, supportable: user)
		user_action.destroy
		redirect_to user
	end

end
