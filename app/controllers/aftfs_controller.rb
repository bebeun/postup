class AftfsController < ApplicationController
	def create
		conversation = Conversation.find(params[:conversation_id]) if !params[:conversation_id].nil?
		redirect_to conversation and return if !user_signed_in? || !current_user.can_aftf?(conversation)
		Aftf.create!(conversation: conversation, creator: current_user)
		redirect_to conversation
	end
	
	def support
		aftf = Aftf.find(params[:id])
		redirect_to aftf.conversation and return if !user_signed_in? || !current_user.can_s_or_u_aftf?(aftf) || aftf.supporters.include?(current_user)
		aftf.unsupporters.destroy(current_user) if aftf.unsupporters.include?(current_user)
		aftf.supporters << current_user 
		redirect_to aftf.conversation
	end
	
	def unsupport
		aftf = Aftf.find(params[:id])
		redirect_to aftf.conversation and return if !user_signed_in? || !current_user.can_s_or_u_aftf?(aftf) || aftf.unsupporters.include?(current_user)
		aftf.supporters.destroy(current_user) if aftf.supporters.include?(current_user)
		aftf.unsupporters << current_user 
		redirect_to aftf.conversation
	end
	
	def remove
		aftf = Aftf.find(params[:id])
		redirect_to aftf.conversation and return if !user_signed_in? || !current_user.can_s_or_u_aftf?(aftf) 
		aftf.supporters.destroy(current_user) if aftf.supporters.include?(current_user)
		aftf.unsupporters.destroy(current_user) if aftf.unsupporters.include?(current_user)
		redirect_to aftf.conversation
	end
	
	def accept
		aftf = Aftf.find(params[:id])
		redirect_to aftf.conversation and return if !user_signed_in? || !current_user.can_call?(aftf.conversation) || !aftf.alive?
		call = Call.new(conversation: aftf.conversation, callable: aftf.creator, parent: current_user.parent_call(aftf.conversation)) 
		#switch aftf s/u to call s/u !!! ================================> inherited = true
		call.supporters << current_user
		call.save!
		aftf.answer_call = call.parent
		aftf.accepted = true
		aftf.save!
		redirect_to aftf.conversation
	end
	
	def refuse
		aftf = Aftf.find(params[:id])
		redirect_to aftf.conversation and return if !user_signed_in? || !current_user.can_call?(aftf.conversation) || !aftf.alive?
		aftf.answer_call = current_user.parent_call(aftf.conversation)
		aftf.accepted = false
		aftf.save!
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
