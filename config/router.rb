# Merb::Router is the request routing mapper for the merb framework.
#
# You can route a specific URL to a controller / action pair:
#
#   r.match("/contact").
#     to(:controller => "info", :action => "contact")
#
# You can define placeholder parts of the url with the :symbol notation. These
# placeholders will be available in the params hash of your controllers. For example:
#
#   r.match("/books/:book_id/:action").
#     to(:controller => "books")
#   
# Or, use placeholders in the "to" results for more complicated routing, e.g.:
#
#   r.match("/admin/:module/:controller/:action/:id").
#     to(:controller => ":module/:controller")
#
# You can also use regular expressions, deferred routes, and many other options.
# See merb/specs/merb/router.rb for a fairly complete usage sample.

Merb.logger.info("Compiling routes...")
Merb::Router.prepare do |r|
  # RESTful routes
  r.resources :users
  r.resources :sessions
  r.to(:controller => 'session') do |s|
    s.match('/login').to(:action => 'new').name(:login)
    s.match('/logout').to(:action => 'destroy').name(:logout)
  end
  r.resource :session
  r.to(:controller => 'bills') do |b|
    b.match('/bills/tag').to(:action => 'by_tag').name(:bill_tag)
  end
  r.resources :bills
  r.to(:controller => 'groups') do |b|
    b.match('/groups/tag').to(:action => 'by_tag').name(:group_tag)
  end
  r.resources :groups
  r.resources :people
  r.to(:controller => 'polls') do |b|
    b.match('/polls/tag').to(:action => 'by_tag').name(:poll_tag)
  end
  r.resources :polls
  r.resources :votes
  
  r.to(:controller => 'forums') do |f|
    f.match('/forums/group').to(:action => 'group_index').name(:group_index)
    f.match('/forums/poll').to(:action => 'poll_index').name(:poll_index)
    f.match('/forums/bill').to(:action => 'bill_index').name(:bill_index)
  end
  r.resources :forums

  r.resources :topics
  r.resources :posts

  r.resources :adviser_relationships
  r.resources :contact_relationships
  r.resources :group_relationships

  r.to(:controller => 'pages') do |p|
    p.match('/terms').to(:action => 'terms').name(:terms)
    p.match('/privacy').to(:action => 'privacy').name(:privacy)
    p.match('/contact_us').to(:action => 'contact_us').name(:contact_us)
    p.match('/about_us').to(:action => 'about_us').name(:about_us)
    p.match('/faq').to(:action => 'faq').name(:faq)
  end

  # This is the default route for /:controller/:action/:id
  # This is fine for most cases.  If you're heavily using resource-based
  # routes, you may want to comment/remove this line to prevent
  # clients from calling your create or destroy actions with a GET
  # r.default_routes
  
  # Change this for your home page to be available at /
  r.match('/start').to(:controller => 'home', :action => 'start').name(:start)
  r.match('/home/map').to(:controller => 'home', :action =>'map').name(:map)
  r.match('/').to(:controller => 'home', :action =>'index').name(:home)
  
  r.match('/feedbacks/create').to(:controller => 'feedbacks', :action => 'create').name(:send_feedback)
end
