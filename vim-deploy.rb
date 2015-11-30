#!/usr/bin/ruby

# Set a comment stripping function - from http://rosettacode.org/wiki/Strip_comments_from_a_string#Ruby
class String
  def strip_comment( markers = ['#',';'] )
    re = Regexp.union( markers ) # construct a regular expression which will match any of the markers
    if index = (self =~ re)
      self[0, index].rstrip      # slice the string where the regular expression matches, and return it.
    else
      rstrip
    end
  end
end

# get my vimrc from github repo

# install pathogen

# get the rest of the plugins as bundles
open("vim-plugins") do |f|
  f.each_line do |plugin|
    plugin = plugin.strip_comment.strip
    if plugin != ''
      puts "Cloning #{plugin} to .vim/bundle"
      exec "git clone https://github.com/#{plugin} ~/.vim/bundletest/#{plugin.split('/')[-1]}"
    end
  end
end

