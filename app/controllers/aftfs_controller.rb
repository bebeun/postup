class AftfsController < ApplicationController
	def create
		conversation = Conversation.find(params[:conversation_id]) if !params[:conversation_id].nil?
		redirect_to conversation and return if !user_signed_in? || !current_user.can_aftf?(conversation)
		aftf = Aftf.create!(conversation: conversation, creator: current_user)
		current_user.supports(aftf)
		redirect_to conversation
	end
	
	
	def support
		aftf = Aftf.find(params[:id])
		redirect_to :back and return if !user_signed_in? || !current_user.can_s_aftf?(aftf) 
		current_user.supports(aftf)
		redirect_to :back
	end
	
	def unsupport
		aftf = Aftf.find(params[:id])
		redirect_to :back and return if !user_signed_in? || !current_user.can_u_aftf?(aftf)
		current_user.unsupports(aftf)
		redirect_to :back
	end
	
	def remove
		aftf = Aftf.find(params[:id])
		redirect_to :back and return if !user_signed_in? || !current_user.can_remove_s_or_u_aftf?(aftf)
		current_user.remove(aftf)
		redirect_to :back
	end
	
	def accept
		aftf = Aftf.find(params[:id])
		redirect_to :back and return if !user_signed_in? || !current_user.can_accept_aftf?(aftf)
		call = Call.create!(conversation: aftf.conversation, callable: aftf.creator, parent: current_user.parent_call(aftf.conversation))
		current_user.supports(call)
		aftf.update_attributes(parent: call.parent, brother_call: call, accepted: true)
		call.transfer_up
		redirect_to :back
	end
	
	def refuse
		aftf = Aftf.find(params[:id])
		redirect_to :back and return if !user_signed_in? || !current_user.can_accept_aftf?(aftf)
		current_user.unsupports(aftf)
		aftf.update_attributes!(parent: current_user.parent_call(aftf.conversation), accepted: false)
		redirect_to :back
	end
	
	def disrefuse
		aftf = Aftf.find(params[:id])
		redirect_to :back and return if !user_signed_in? || !current_user.can_disrefuse_aftf?(aftf) 
		current_user.remove(aftf)
		aftf.update_attributes!(parent: nil, accepted: nil)
		redirect_to :back
	end
	
	def destroy
		aftf = Aftf.find(params[:id])
		redirect_to :back and return if !user_signed_in? || current_user != aftf.creator || !aftf.alive?
		aftf.destroy 
		redirect_to :back
	end
end
