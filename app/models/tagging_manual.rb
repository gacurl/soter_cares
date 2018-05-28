class TaggingManual < ActsAsTaggableOn::Tagging
  def self.tokens(context, query)
    tags = ActsAsTaggableOn::Tag.where("tags.name ilike ?", "%#{query}%")
            .joins(:taggings).where("taggings.context = ?", context).uniq
    if tags.empty?
      [{id: "<<<#{query}>>>", name: "New: \"#{query}\""}]
    else
      tags
    end
  end
end