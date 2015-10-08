class AftfsController < ApplicationController
	def create
		conversation = Conversation.find(params[:conversation_id]) if !params[:conversation_id].nil?
		redirect_to conversation and return if !user_signed_in? || !current_user.can_aftf?(conversation)
		aftf = Aftf.create!(conversation: conversation, creator: current_user)
		aftf.supporters << current_user  # Handling Object S / U
		redirect_to conversation
	end
	
	def support
		aftf = Aftf.find(params[:id])
		redirect_to aftf.conversation and return if !user_signed_in? || !current_user.can_s_or_u_aftf?(aftf) || aftf.supporters.include?(current_user)
		aftf.unsupporters.destroy(current_user) if aftf.unsupporters.include?(current_user)
		aftf.supporters << current_user # Handling Object S / U
		redirect_to aftf.conversation
	end
	
	def unsupport
		aftf = Aftf.find(params[:id])
		redirect_to aftf.conversation and return if !user_signed_in? || !current_user.can_s_or_u_aftf?(aftf) || aftf.unsupporters.include?(current_user)
		aftf.supporters.destroy(current_user) if aftf.supporters.include?(current_user)
		aftf.unsupporters << current_user # Handling Object S / U
		redirect_to aftf.conversation
	end
	
	def remove
		aftf = Aftf.find(params[:id])
		redirect_to aftf.conversation and return if !user_signed_in? 
		aftf.supporters.destroy(current_user) if aftf.supporters.include?(current_user)  # Handling Object S / U
		aftf.unsupporters.destroy(current_user) if aftf.unsupporters.include?(current_user) # Handling Object S / U
		redirect_to aftf.conversation
	end
	
	def accept
		aftf = Aftf.find(params[:id])
		redirect_to aftf.conversation and return if !user_signed_in? || !current_user.can_call?(aftf.conversation) || !aftf.alive?
		call = Call.new(conversation: aftf.conversation, callable: aftf.creator, parent: current_user.parent_call(aftf.conversation))
		call.save!
		call.supporters << current_user # Handling Object S / U    ????????????
		aftf.answer_call = call.parent
		aftf.decider_call = call
		aftf.accepted = true
		aftf.save!
		aftf.unsupporters.destroy(current_user) if aftf.unsupporters.include?(current_user)
		aftf.supporters << current_user if !aftf.supporters.include?(current_user) # Handling Object S / U
		redirect_to aftf.conversation
	end
	
	def refuse
		aftf = Aftf.find(params[:id])
		redirect_to aftf.conversation and return if !user_signed_in? || !current_user.can_call?(aftf.conversation) || !aftf.alive?
		aftf.supporters.destroy(current_user) if aftf.supporters.include?(current_user)
		aftf.unsupporters << current_user if !aftf.unsupporters.include?(current_user) # Handling Object S / U
		aftf.update_attributes!(answer_call: current_user.parent_call(aftf.conversation), accepted: false)
		redirect_to aftf.conversation
	end
	
	def disrefuse
		aftf = Aftf.find(params[:id])
		redirect_to aftf.conversation and return if !user_signed_in? || !current_user.can_disrefuse_aftf?(aftf) 
		aftf.unsupporters.destroy(current_user) # Handling Object S / U
		aftf.update_attributes!(answer_call: nil, accepted: nil)
		redirect_to aftf.conversation
	end
	
	def disaccept
		aftf = Aftf.find(params[:id])
		redirect_to aftf.conversation and return if !user_signed_in? || !current_user.can_disaccept_aftf?(aftf) 
		aftf.decider_call.destroy
		aftf.supporters.destroy(current_user) # Handling Object S / U
		aftf.update_attributes(answer_call: nil, decider_call: nil, accepted: nil)
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
