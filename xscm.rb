#!/usr/bin/env ruby
require 'thor'

class XScm < Thor
  desc "commit", ""
  def commit
    cmd_str = 'git add --all && git commit -m "update"'
  end

  desc "push remote", ""
  def push(remote_name)
    remote="local"
    if !remote_name.empty?
      remote=remote_name
    end

    cmd_str = "git add --all && git commit -m \"update\""
    system(cmd_str)
    system("git push #{remote} master")
  end

  desc "tag remote tag", ""
  def tag(remote_name, tag_name)
    tag=tag_name
    remote=remote_name


    cmd_str = "git tag -d #{tag_name} && git tag #{tag} && git push local :#{tag} && git push #{remote} #{tag}"
    system(cmd_str)

  end

  desc "pod update",""
  def pod(action)
    if action.eql?"update"
      system("pod update --no-repo-update")
    elsif action.eql? "install"
      system("pod install --no-repo-update")
    end
  end
end

XScm.start
