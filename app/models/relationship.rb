class Relationship < ActiveRecord::Base
  belongs_to :contact
  belongs_to :relation, class_name: "Contact", foreign_key: :relation_id
  belongs_to :relationship_type
  has_one    :decision_maker
  
  after_create :opposite_relationship
  
  def name
    if self.relation.gender == "Male"
      self.relation.first_name + " " + self.relation.last_name + " - " + self.relationship_type.male_opposite
    elsif self.relation.gender == "Female"
      self.relation.first_name + " " + self.relation.last_name + " - " + self.relationship_type.female_opposite
    end
  end
  
  def opposite_relationship
    relation = Relationship.new
    relation.relationship_type = RelationshipType.find_by(name: self.relationship_type.entanglement)
    
    relation.in_law = self.in_law
    relation.step = self.step
    relation.great = self.great
    
    relation.contact_id = self.relation_id
    relation.relation_id = self.contact_id
    if self.relation.relationships.where(relation_id: self.contact_id).empty?
      relation.save
    end
  end
end