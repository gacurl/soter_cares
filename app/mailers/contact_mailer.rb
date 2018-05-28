class ContactMailer < ApplicationMailer
  include ActionView::Helpers::NumberHelper
  
  def validation(contact, prospect_id)
    template_name = 'soter-validation'
    template_content = []
    message = {
      to: [{email: contact.email }],
      merge_vars: [
        {rcpt: contact.email,
        vars: [
          { name: "VALIDATE", content: "#{edit_validation_url(contact.id, email: contact.email, prospect_id: prospect_id)}" }
          ]
        }
        ]
      }
      
      mandrill_client.messages.send_template template_name, template_content, message
  
  end
  
  def lead(community, prospect_id, lead_id)
    lead = Contact.find_by_id(lead_id)
    prospect = Contact.find_by_id(prospect_id)
    
    case prospect.gender
    when "Male"
      relation =  prospect.relationships.find_by(relation: lead).relationship_type.male_name
    when "Female"
      relation =  prospect.relationships.find_by(relation: lead).relationship_type.female_name
    else
      relation = "Unknown"
    end
    
    text = "A potential prospect was identified on The Soter Family Advocates website. The visitor to the website has selected the following community to be on their watch list:\n"
    text += "#{community.name} - #{community.zip_code.city.name}, #{community.zip_code.city.county.state.two_digit_code}\n"
    text += "Case ID: #{prospect.case_id}\n"
    text += "Prospect name: #{prospect.first_name} #{prospect.last_name}\n"
    text += "Gender: #{prospect.gender}\n"
    text += "Lead name: #{lead.first_name} #{lead.last_name}\n" unless lead == prospect
    text += "Prospect relationship: #{relation}\n" unless lead == prospect
    text += "Clinical Needs:\n"
    prospect.license_list.each do |need|
      text += need + "\n"
    end
    text += "\n"
    text += "Desired Acitivies:\n"
    prospect.activity_list.each do |activity|
      text += activity + "\n"
    end
    text += "\n"
    text += "Veteran Status: #{prospect.veteran}"
    text += "\n"
    text += "Notes:\n"
    prospect.notes.each do |note|
      text += note.content + "\n"
    end
    
    if community.marketing_director && community.marketing_director.work_email
      email = community.marketing_director.work_email
      name = "#{community.marketing_director.first_name} #{community.marketing_director.last_name}"
    elsif community.executive_director && community.executive_director.work_email
      email = community.executive_director.work_email
      name = "#{community.executive_director.first_name} #{community.executive_director.last_name}"
    else
      email = "info@sotercares.com"
      name = "Soter Info"
    end
          
    message = {
      from_name: "Soter Family Advocates",
      from_email: "no-reply@sotercares.com",
      subject: "Sales Lead",
      to: [{email: email,
            name: name }],
      text: text
      }
      
      mandrill_client.messages.send message
  end
  
  def mandrill_client
    @mandrill_client ||= Mandrill::API.new Rails.application.secrets.mandrill_key
  end
end