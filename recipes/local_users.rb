# Cookbook Name:: stig
# Recipe:: local_users
# Author: Craig Poma <cpoma@mitre.org>
#
# Description: Remove users and folders that do not belong. Set shells for
# various service accounts.
#
# Remove Directories first, some may be related to
# users getting deleted below.
node.default['stig']['local_users']['dirs_to_delete']['dir'].each do |dir|
  directory dir do
    action :delete
  end
end

node.default['stig']['local_users']['users_to_delete']['user'].each do |user|
  user user do
    username user
    manage_home true
    action  :remove
    only_if node.default['stig']['local_users']['users_to_delete'][user].to_s
    only_if "getent passwd #{user}"
  end
end

node.default['stig']['local_users']['users_default_shell']['user'].each do |user|
  user user do
    username user
    action  :modify
    shell   '/sbin/nologin'
    not_if  "(grep -E \"(^/#{user}/(*.)+/sbin/nologin$)\" /etc/passwd)"
  end
end
