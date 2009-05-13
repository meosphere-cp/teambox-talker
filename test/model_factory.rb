module ModelFactory
  def hash_for_user(attributes={})
    { :name => 'Clark Kent', :account => Account.first }.merge(attributes)
  end
  
  def hash_for_account(attributes={})
    { :subdomain => 'super-awesome' }.merge(attributes)
  end
  
  def hash_for_room(attributes={})
    { :name => 'Main', :account => Account.first }.merge(attributes)
  end
  
  def hash_for_message(attributes={})
    { :content => '...', :room => Room.first, :user => User.first }.merge(attributes)
  end
  
  # Simulates model creation methods based on has_for_<model_name>:
  #   create_<model_name>:  will instantiate w/ attributes and call save
  #   create_<model_name>!: will instantiate w/ attributes and call save!
  #   build_<model_name>:   will instantiate w/ attributes (wont' save)
  def method_missing(method, *args)
    case
    when name = method.to_s.match(/^create_(\w+)(!|)$/)
      returning new_instance(name[1], send("hash_for_#{name[1]}", *args)) do |instance|
        name[2] == '!' ? instance.save! : instance.save
      end
    when name = method.to_s.match(/^build_(\w+)$/)
      new_instance name[1], send("hash_for_#{name[1]}", *args)
    else
      super
    end
  end
  
  private
    # Ensure we can use hash to initialize attributes even when attr_protected is used on models
    def new_instance(name, attributes)
      instance = name.to_s.classify.constantize.new
      attributes.each_pair { |attr, value| instance.send "#{attr}=", value }
      instance
    end
  
end