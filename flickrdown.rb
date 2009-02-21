#!/usr/bin/env ruby

require 'open-uri'

if ARGV.length < 1
  raise Exception, 'ARGV[0] should be the username'
end

user = ARGV[0]

url = "http://www.flickr.com/photos/#{user}/page%d"
purl = "http://www.flickr.com/photos/#{user}/%s/sizes/o/"

photos = []

8.times {|n|
  u = url % (n+1)
  open(u) {|f|
    photos += f.read.split(/\r\n|\n/).grep(/StreamView/).delete_if {|s|
      s =~ /title/
    }.map {|s|
      s.sub(/^.+?sv_body_(\d+)">$/,'\1')
    }
  }
}

img = []

photos.each {|s|
  u = purl % s
  open(u) {|f|
    f.read.split(/\r\n|\n/).grep(/Download the Large/).each {|s|
      img << s.match(/href="(.+?)"/)[1]
    }
  }
}

puts img.join("\n")
