#!/usr/bin/env ruby
require 'thor'

class XGit < Thor
  desc "commit", ""
  def commit
    cmd_str = 'git add --all && git commit -m "update"'
  end

  desc "push", ""
  def push
    cmd_str = 'git add --all && git commit -m "update"'
    system(cmd_str)
    system("git push local master")
  end

  desc "tag remote tag", ""
  def tag(remote_name, tag_name)
    tag=tag_name
    remote=remote_name


    cmd_str = "git tag -d #{tag_name} && git tag #{tag} && git push local :#{tag} && git push #{remote} #{tag}"
    system(cmd_str)

  end
end

XGit.start
