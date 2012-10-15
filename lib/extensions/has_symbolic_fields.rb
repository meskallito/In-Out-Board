module HasSymbolicField
  extend ActiveSupport::Concern

  module ClassMethods
    # Defining (all below are equivalent):
    #  - has_symbolic_field :status, [:active, :pending]
    #  - has_symbolic_field :status, :active => 'Active', :pending => 'Pending'
    #  - has_symbolic_field :status, :active => 'Active', :pending => nil
    # Accessing:
    # - it.status # :available
    # - it.status = :pending
    # - it.status = 'available'
    # - it.status_name # "Available"
    # - it.status_hash.keys # [:active, :pending]
    # - it.status_hash.values # ["Active", "Pending"]
    # - it.status_allowed? :random # false
    # - it.status = :random # error
    def has_symbolic_field(field, options={})
      clazz = self
      options ||= {}
      raise "Please provide the available options hash for #{clazz.name}##{field}." if options.empty?
      # For array, convert it to Hash magically
      options = Hash[ options.map {|v| [v.to_s.underscore.to_sym, v.to_s.humanize] } ] unless options.respond_to? :keys

      options.each_pair do |k,v|
        options[k] = k.to_s.humanize if v.blank?
      end

      clazz.send(:define_method, "#{field}_allowed?") do |value|
        return true if value.blank?
        options.keys.include? value.to_sym
      end

      clazz.send(:define_method, "#{field}_name") do
        key = read_attribute(field).try(:to_sym)
        options[key]
      end

      # define user.status_hash
      clazz.send(:define_method, "#{field}_hash") do
        options
      end

      # define User.status_hash
      clazz.define_singleton_method "#{field}_hash" do
        options
      end

      clazz.send(:define_method, field) do
        read_attribute(field).try(:to_sym)
      end
      clazz.send(:define_method, "#{field}=") do |value|
        raise "The value '#{value}' for #{clazz.name}##{field} is not allowed." unless send("#{field}_allowed?", value)
        write_attribute field, value.try(:to_s)
      end

    end
  end

end

::ActiveRecord::Base.send(:include, HasSymbolicField)
