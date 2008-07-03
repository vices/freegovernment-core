Merb::Config.use do |c|
  c[:session_id_key] = '_session_id'
  c[:session_secret_key]  = '04c7f72a37e356776ae20f81ffec78573a864493'
  c[:session_store] = 'memory'
end
