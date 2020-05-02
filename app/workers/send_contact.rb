class SendContact
  include Sidekiq::Worker

  def perform(user_id, medicaid_provider_ids, medical_needs, activity_tags, dining_tags, interest_ids, contact_id)
    contact = Contact.find(contact_id)
    user = User.find_by(email: 'troy@sotercares.com')
    message = "WEBSITE LEAD\n"
    message += "Name: " + contact.name + "\n"
    message += "Cell Phone: " + contact.cell_phone + "\n"
    message += "Email: " + contact.email + "\n\n"
    message += "MEDICAID PROVIDERS:\n"
    MedicaidProvider.where(id: medicaid_provider_ids).each do |mp|
      message += mp.name + "\n"
    end
    message += "\nMedical Needs:\n"
    message += ActsAsTaggableOn::Tag.where(id: medical_needs).pluck(:name).join(', ')
    message += "\nActivities:\n"
    message += activity_tags.join(',') + "\n"
    message += "\nLanguages:\n"
    message += dining_tags.join(', ') + "\n"

    message += "\nINTERESTED COMMUNITIES\n"
    interest_communities = Community.where(id: interest_ids).distinct
    contact.prospects << interest_communities
    interest_communities.each do |community|
      message += community.name + '-' + community.id.to_s + "\n"
    end

    contact.results << Result.new(result_type: ResultType.find_by(name: "Qualified, OK to pursue"))

    user.send_notification_email(message)
  end
end