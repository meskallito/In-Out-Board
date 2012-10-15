# Use create instead of FactoryGirl.create etc
# It gives us:
#   attributes_for, build, create, build_stubbed, build_list(name, amount, overrides), create_list, generate(sequence_name)
RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end
