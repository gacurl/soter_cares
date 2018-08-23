class UserMailer < ApplicationMailer
  include ActionView::Helpers::NumberHelper

  def notification(user_id, message)
    user = User.find_by_id(user_id)

    message = {
        from_name: "SoterCares",
        from_email: "no-reply@#{ENV['HOST_URL']}",
        subject: "System Notification",
        to: [{email: user.email,
              name: user.email}],
        text: message
    }

    mandrill_client.messages.send message
  end

  def initial_lead(email, prospect_id, lead_id)
    lead = Contact.find_by_id(lead_id)
    prospect = Contact.find_by_id(prospect_id)
    
    text = "A new website lead is available. The prospective client's name is #{prospect.first_name} #{prospect.last_name}. The lead's name is #{lead.first_name} #{lead.last_name}."
    
    message = {
      from_name: "Soter Family Advocates",
      from_email: "no-reply@sotercares.com",
      subject: "New Website Lead",
      to: [{email: email,
            name: email}],
      text: text
      }
      
      mandrill_client.messages.send message
  end
  
  def lead(user, prospect_id)
    prospect = Contact.find_by_id(prospect_id)
    
    text = "A new case has been assigend to you. The prospective client's name is #{prospect.first_name} #{prospect.last_name}."
    
    message = {
      from_name: "Soter Family Advocates",
      from_email: "no-reply@sotercares.com",
      subject: "New Website Case",
      to: [{email: user.email,
            name: user.email}],
      text: text
      }
      
      mandrill_client.messages.send message
  end
  
  
  def password_reset(user)
    template_name = 'soter-password-reset'
    template_content = []
    message = {
      to: [{email: user.email }],
      merge_vars: [
        {rcpt: user.email,
        vars: [
          { name: "RESET", content: "#{edit_password_reset_url(user.reset_token,
                                                      email: user.email)}" }
          ]
        }
        ]
      }
      
      mandrill_client.messages.send_template template_name, template_content, message
  end
  
  
  def account_activation(user)
    template_name = 'soter-activation'
    template_content = []
    message = {
      to: [{email: user.email }],
      merge_vars: [
        {rcpt: user.email,
        vars: [
          { name: "ACTIVATE", content: "#{edit_account_activation_url(user.activation_token, 
                                      email: user.email)}" }
          ]
        }
        ]
      }
      
      mandrill_client.messages.send_template template_name, template_content, message
  
  end
  
  def mandrill_client
    @mandrill_client ||= Mandrill::API.new Rails.application.secrets.mandrill_key
  end
end