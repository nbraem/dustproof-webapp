module SharedAccessor
  module FullName
    def full_name
      full_name = []
      full_name << first_name if first_name.present?
      full_name << last_name if last_name.present?
      full_name.empty? ? nil : full_name.join(" ")
    end
  end
end
