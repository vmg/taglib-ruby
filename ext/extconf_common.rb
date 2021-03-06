# Default opt dirs to help mkmf find taglib
configure_args = "--with-opt-dir=/usr/local:/opt/local:/sw "
ENV['CONFIGURE_ARGS'] = configure_args + ENV.fetch('CONFIGURE_ARGS', "")

require 'mkmf'

def error msg
  message msg + "\n"
  abort
end

dir_config('tag')

# When compiling statically, -lstdc++ would make the resulting .so to
# have a dependency on an external libstdc++ instead of the static one.
unless $LDFLAGS.split(" ").include?("-static-libstdc++")
  if not have_library('stdc++')
    error "You must have libstdc++ installed."
  end
end

if not have_library('tag')
  error <<-DESC
You must have taglib installed in order to use taglib-ruby.

Debian/Ubuntu: sudo apt-get install libtag1-dev
Fedora/RHEL: sudo yum install taglib-devel
Brew: brew install taglib
MacPorts: sudo port install taglib
DESC
end

$CFLAGS << " -DSWIG_TYPE_TABLE=taglib"
