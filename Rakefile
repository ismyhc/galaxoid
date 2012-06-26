#!/usr/bin/env ruby
require 'releasy'
require 'rubygems' rescue nil
require 'bundler/setup' # Releasy doesn't require that your application uses bundler, but it does make things easier.
$LOAD_PATH.unshift File.join(File.expand_path(__FILE__), "..", "..", "lib")

#<<<
Releasy::Project.new do
  name "Galaxoid"
  version "0.1"

  executable "main.rb"
  verbose
  files '**/*.*'
  exposed_files "README.markdown"
  add_link "http://my_application.github.com", "My Application website"
  exclude_encoding # Applications that don't use advanced encoding (e.g. Japanese characters) can save build size with this.

  # Create a variety of releases, for all platforms.
  add_build :osx_app do
    url "com.github.galaxoid"
    wrapper "wrappers/gosu-mac-wrapper-0.7.41.tar.gz" # Assuming this is where you downloaded this file.
    #icon "media/icon.icns"
    add_package :tar_gz
  end

end
#>>>