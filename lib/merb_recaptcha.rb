module Merb
  #module Helpers
  module Ambethia
    def self.load
      require 'builder'
      Kernel.load(File.join(File.dirname(__FILE__) / 'merb_recaptcha/recaptcha.rb'))
    end
  end
end

# make sure we're running inside Merb
if defined?(Merb::Plugins)

  # Merb gives you a Merb::Plugins.config hash...feel free to put your stuff in your piece of it
  #Merb::Plugins.config[:merb_recaptcha] = {
    #:chickens => false
  #}
  
  Merb::BootLoader.before_app_loads do
    # require code that must be loaded before the application

    Merb::Ambethia.load
  end
  
  #Merb::BootLoader.after_app_loads do
    # code that can be required after the application loads
  #end
  
  #Merb::Plugins.add_rakefiles "merb_recaptcha/merbtasks"
end
