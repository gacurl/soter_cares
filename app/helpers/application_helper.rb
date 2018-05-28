module ApplicationHelper
    def full_title(page_title = '') # Method def, optional arg
        base_title = "Soter Senior Living & Family Advocates" # Variable assignment
        if page_title.empty? # Boolean test
            base_title # Implicit return
        else
            "#{page_title} | #{base_title}" # String interpolation
        end
    end
    
    def cp(path)
        "active" if current_page?(path)
    end
    
    def nl2br(s)
      s.gsub(/\n/, '<br>') unless s.blank?
    end
end
