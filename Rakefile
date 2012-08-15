require 'releasy'
require 'rubygems' rescue nil
#require 'bundler/setup' # Releasy doesn't require that your application uses bundler, but it does make things easier.
require 'rake/testtask'

#<<<
Releasy::Project.new do
  name "Galaxoid"
  version "Alpha-v0.3"

  executable "lib/main.rb"
  verbose
  files ['lib/*.rb', 'lib/images/*.*', 'lib/fonts/*.*', 'lib/songs/*.*', 'lib/sounds/*.*']
  #exposed_files "README.markdown"
  add_link "http://github.com/ismyhc/galaxoid", "Galaxoid on Github"
  exclude_encoding # Applications that don't use advanced encoding (e.g. Japanese characters) can save build size with this.

  # Create a variety of releases, for all platforms.
  add_build :osx_app do
    url "com.github.galaxoid"
    wrapper "wrappers/gosu-mac-wrapper-0.7.41.tar.gz" # Assuming this is where you downloaded this file.
    icon "icons/icon.icns"
    add_package :tar_gz
  end
  
  # If unable to build on a Windows machine, :windows_wrapped is the only choice.
  add_build :windows_wrapped do
    wrapper "wrappers/ruby-1.9.3-p0-i386-mingw32.7z" # Assuming this is where you downloaded this file.
    executable_type :windows # Assuming you don't want it to run with a console window.
    exclude_tcl_tk # Assuming application doesn't use Tcl/Tk, then it can save a lot of size by using this.
    add_package :zip
  end

  add_build :windows_installer do
    icon "icons/icon.ico"
    start_menu_group "Galaxoid-Alpha-v_0_2_WIN32"
    readme "README.markdown" # User asked if they want to view readme after install.
    license "LICENSE.txt" # User asked to read this and confirm before installing.
    executable_type :windows # Assuming you don't want it to run with a console window.
    add_package :zip
  end

  add_build :windows_folder do
    icon "icons/icon.ico"
    executable_type :windows # Assuming you don't want it to run with a console window.
    add_package :exe
  end

  add_build :windows_standalone do
    icon "icons/icon.ico"
    executable_type :windows # Assuming you don't want it to run with a console window.
    add_package :exe
  end

end
#>>>
