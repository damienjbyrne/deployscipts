#!/usr/bin/ruby

require 'open-uri'

vim_dir = File.expand_path("~/.vim")
autoload_dir = "#{vim_dir}/autoload"

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
vimrc_file_path = File.expand_path("~/.vimrc")
open("https://raw.githubusercontent.com/damienjbyrne/dotfiles/master/vimrc") do |fin|
  open(vimrc_file_path, 'w') { |fout| fout.write(fin.read) }
end

# start setting things up in ~/.vim
Dir.mkdir(vim_dir) unless File.exists?(vim_dir)

# install pathogen if it's not there already
Dir.mkdir(autoload_dir) unless File.exists?(autoload_dir)
pathogen_file_path = "#{autoload_dir}/pathogen.vim"
unless File.exists?(pathogen_file_path)
  open("https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim") do |pathin|
    open("#{pathogen_file_path}", 'w') { |path_file| path_file.write(pathin.read) }
  end
end

# get the rest of the plugins as bundles
bundle_dir = "#{vim_dir}/bundle"
open("vim-plugins") do |f|
  f.each_line do |plugin|
    plugin = plugin.strip_comment.strip
    if plugin != ''
      plugin_dir = "#{bundle_dir}/#{plugin.split('/')[-1]}"
      puts "*** checking for #{plugin_dir}"
      if Dir.exist?(plugin_dir)
        puts "Updating #{plugin} in #{plugin_dir}"
        system "git -C #{plugin_dir} pull"
      else
        puts "Cloning #{plugin} to #{plugin_dir}"
        system "git clone https://github.com/#{plugin} #{plugin_dir}"
      end
    end
  end
end

