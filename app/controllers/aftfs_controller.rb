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
		redirect_to aftf.conversation and return if !user_signed_in? || !current_user.can_s_aftf?(aftf) 
		current_user.supports(aftf)
		redirect_to aftf.conversation
	end
	
	def unsupport
		aftf = Aftf.find(params[:id])
		redirect_to aftf.conversation and return if !user_signed_in? || !current_user.can_u_aftf?(aftf)
		current_user.unsupports(aftf)
		redirect_to aftf.conversation
	end
	
	def remove
		aftf = Aftf.find(params[:id])
		redirect_to aftf.conversation and return if !user_signed_in? || !current_user.can_remove_s_or_u_aftf?(aftf)
		current_user.remove(aftf)
		redirect_to aftf.conversation
	end
	
	def accept
		aftf = Aftf.find(params[:id])
		redirect_to aftf.conversation and return if !user_signed_in? || !current_user.can_accept_aftf?(aftf)
		call = Call.create!(conversation: aftf.conversation, callable: aftf.creator, parent: current_user.parent_call(aftf.conversation))
		current_user.supports(aftf)
		aftf.update_attributes(answer_call: call.parent, decider_call: call, accepted: true)
		call.transfer_call_s_u_up
		redirect_to aftf.conversation
	end
	
	def refuse
		aftf = Aftf.find(params[:id])
		redirect_to aftf.conversation and return if !user_signed_in? || !current_user.can_accept_aftf?(aftf)
		current_user.unsupports(aftf)
		aftf.update_attributes!(answer_call: current_user.parent_call(aftf.conversation), accepted: false)
		redirect_to aftf.conversation
	end
	
	def disrefuse
		aftf = Aftf.find(params[:id])
		redirect_to aftf.conversation and return if !user_signed_in? || !current_user.can_disrefuse_aftf?(aftf) 
		current_user.remove(aftf)
		aftf.update_attributes!(answer_call: nil, accepted: nil)
		redirect_to aftf.conversation
	end
	
	def destroy
		aftf = Aftf.find(params[:id])
		conversation = aftf.conversation
		redirect_to aftf.conversation and return if !user_signed_in? || current_user != aftf.creator || !aftf.alive?
		aftf.destroy 
		redirect_to conversation
	end
end
