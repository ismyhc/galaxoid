require 'releasy'
require 'rubygems' rescue nil
require 'bundler/setup' # Releasy doesn't require that your application uses bundler, but it does make things easier.

#<<<
Releasy::Project.new do
  name "Galaxoid"
  version "0.1"

  executable "lib/main.rb"
  verbose
  files ['lib/*.rb', 'lib/images/*.*', 'lib/fonts/*.*', 'lib/songs/*.*', 'lib/sounds/*.*']
  exposed_files "README.markdown"
  add_link "http://github.com/ismyhc/galaxoid", "Galaxoid Github"
  exclude_encoding # Applications that don't use advanced encoding (e.g. Japanese characters) can save build size with this.

  # Create a variety of releases, for all platforms.
  add_build :osx_app do
    url "com.github.galaxoid"
    wrapper "wrappers/gosu-mac-wrapper-0.7.41.tar.gz" # Assuming this is where you downloaded this file.
    #icon "media/icon.icns"
    add_package :tar_gz
  end
  
  # If unable to build on a Windows machine, :windows_wrapped is the only choice.
  add_build :windows_wrapped do
    wrapper "wrappers/ruby-1.9.3-p0-i386-mingw32.7z" # Assuming this is where you downloaded this file.
    executable_type :windows # Assuming you don't want it to run with a console window.
    exclude_tcl_tk # Assuming application doesn't use Tcl/Tk, then it can save a lot of size by using this.
    add_package :zip
  end

end
#>>>