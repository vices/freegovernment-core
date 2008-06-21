require 'rubygems'
gem 'ParseTree'
require 'parse_tree'
#
# ==== Structure of Merb initializer
#
# 1. Load paths.
# 2. Dependencies configuration.
# 3. Libraries (ORM, testing tool, etc) you use.
# 4. Application-specific configuration.

#
# ==== Set up load paths
#

# Make the app's "gems" directory a place where gems are loaded from.
# Note that gems directory must have a structure RubyGems uses for
# directories under which gems are kept.
#
# To conveniently set it up use gem install -i <merb_app_root/gems>
# when installing gems. This will set up the structure under /gems
# automagically.
#
# An example:
#
# You want to bundle ActiveRecord and ActiveSupport with your Merb
# application to be deployment environment independent. To do so,
# install gems into merb_app_root/gems directory like this:
#
# gem install -i ~/dev/merbapp/gems activesupport-post-2.0.2gem activerecord-post-2.0.2.gem
#
# Since RubyGems will search merb_app_root/gems for dependencies, order
# in statement above is important: we need to install ActiveSupport which
# ActiveRecord depends on first.
#
# Remember that bundling of dependencies as gems with your application
# makes it independent of the environment it runs in and is a very
# good, encouraged practice to follow.
Gem.clear_paths
Gem.path.unshift(Merb.root / "gems")

# If you want modules and classes from libraries organized like
# merbapp/lib/magicwand/lib/magicwand.rb to autoload,
# uncomment this.
# Merb.push_path(:lib, Merb.root / "lib") # uses **/*.rb as path glob.


# ==== Dependencies

# These are some examples of how you might specify dependencies.
# Dependencies load is delayed to one of later Merb app
# boot stages. It may be important when
# later part of your configuration relies on libraries specified
# here.
#
# dependencies "RedCloth", "merb_helpers"
# OR
# dependency "RedCloth", "> 3.0"
# OR
# dependencies "RedCloth" => "> 3.0", "ruby-aes-cext" => "= 1.0"
dependency 'digest/sha1'
dependency 'merb-action-args'
dependency 'merb-assets'
dependency 'merb-haml'
dependency 'merb_helpers'
dependency 'dm-timestamps'
dependency 'dm-validations'
dependency 'dm-aggregates'
dependency 'dm-geokit'
if Merb.environment == 'test'
  dependency 'merb_stories'
end
dependency 'lib/merb_recaptcha'
dependency 'net/http'
Merb::BootLoader.after_app_loads do
  # Add dependencies here that must load after the application loads:

  # dependency "magic_admin" # this gem uses the app's model classes
  require File.join(File.dirname(__FILE__),'recaptcha')
  require File.join(File.dirname(__FILE__),'geokit')
end

#
# ==== Set up your ORM of choice
#

# Merb doesn't come with database support by default.  You need
# an ORM plugin.  Install one, and uncomment one of the following lines,
# if you need a database.

# Uncomment for DataMapper ORM
 use_orm :datamapper

# Uncomment for ActiveRecord ORM
# use_orm :activerecord

# Uncomment for Sequel ORM
# use_orm :sequel


#
# ==== Pick what you test with
#

# This defines which test framework the generators will use
# rspec is turned on by default
#
# Note that you need to install the merb_rspec if you want to ue
# rspec and merb_test_unit if you want to use test_unit.
# merb_rspec is installed by default if you did gem install
# merb.
#
# use_test :test_unit
 use_test :rspec


#
# ==== Set up your basic configuration
#
Merb::Config.use do |c|

  # Sets up a custom session id key, if you want to piggyback sessions of other applications
  # with the cookie session store. If not specified, defaults to '_session_id'.
  # c[:session_id_key] = '_session_id'

  c[:session_secret_key]  = '04c7f72a37e356776ae20f81ffec78573a864493'
  c[:session_store] = 'memory'
end


# ==== Tune your inflector

# To fine tune your inflector use word, singular_word and plural_word
# methods of Language::English::Inflector module metaclass.
#
# Here we define erratum/errata exception case:
#
# Language::English::Inflector.word "erratum", "errata"
#
# In case singular and plural forms are the same omit
# second argument on call:
#
# Language::English::Inflector.word 'information'
#
# You can also define general, singularization and pluralization
# rules:
#
# Once the following rule is defined:
# Language::English::Inflector.rule 'y', 'ies'
#
# You can see the following results:
# irb> "fly".plural
# => flies
# irb> "cry".plural
# => cries
#
# Example for singularization rule:
#
# Language::English::Inflector.singular_rule 'o', 'oes'
#
# Works like this:
# irb> "heroes".singular
# => hero
#
# Example of pluralization rule:
# Language::English::Inflector.singular_rule 'fe', 'ves'
#
# And the result is:
# irb> "wife".plural
# => wives
