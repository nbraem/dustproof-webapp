# Helps build attributes with association
# See https://stackoverflow.com/questions/10290286/factorygirl-why-does-attributes-for-omit-some-attributes

def build_attributes(*args)
  FactoryGirl.build(*args).attributes.delete_if do |k, v|
    ["id", "created_at", "updated_at"].member?(k)
  end
end
