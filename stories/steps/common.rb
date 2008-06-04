steps_for :common do

  @request_format = :html
  
  When "I request an XML response" do
    @request_format = :xml
  end


  When "I request a JSON response" do
    @request_format = :json
  end
  
  Then "$number new $model should be created" do |number, model|
    klass = Object.full_const_get(model.singularize.to_const_string)
    count = klass.count
    count.should == number.to_i
  end

end


