class UsersController < ApplicationController
	def show
		@postscreated = Post.where(creator: current_user)
		@postssupported = Post.select { |w| (w.supporters.include?(current_user) || w.unsupporters.include?(current_user))}
		@callins = current_user.callins
		@callouts = current_user.callouts
		@callssupported = Call.select { |w| (w.supporters.include?(current_user) || w.unsupporters.include?(current_user))}
		
		@conversations = @postscreated.collect{|x| x.conversation } + @postssupported.collect{|x| x.conversation } + @callins.collect{|x| x.conversation } + @callouts.collect{|x| x.conversation } + @callssupported.collect{|x| x.conversation }
	end
end
