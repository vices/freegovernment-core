Module GroupsSpecHelper
    def do_get(controller, method, params = nil, &block)
      dispatch_to(controller, :method, params) do |controller|
        controller.stub!(:render)
        block if block_given?
      end
    end
end