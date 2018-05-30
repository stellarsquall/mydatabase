#
# Cookbook:: mydatabase
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

apt_update 'update'

package node['mydatabase']['postgres_package']

service 'postgresql' do
	action [ :start, :enable ]
end

template node['mydatabase']['pg_hba'] do
  source "pg_hba_#{node['platform']}.erb"
  variables(
  	database_user: 'database_user'
  )
  notifies :reload, 'service[postgresql]', :immediately
end

execute "createdb roux" do
  user 'postgres'
  not_if "psql --dbname=roux"
end

execute "psql roux -c \"CREATE ROLE database_user PASSWORD 'user_password' SUPERUSER LOGIN;\"" do
	user 'postgres'
	not_if "psql -c '\\du' | grep database_user"
end