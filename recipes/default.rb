#
# Cookbook:: mydatabase
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

apt_update 'update'

package 'postgresql'

service 'postgresql' do
	action [ :start, :enable ]
end

user 'database_user'

sudo 'admins' do
  users 'database_user'
end

template '/etc/postgresql/9.5/main/pg_hba.conf' do
  source 'pg_hba_ubuntu.erb'
  variables(
  	database_user: 'database_user'
  )
  notifies :reload, 'service[postgresql]', :immediately
end

execute "createuser database_user --superuser" do
  user 'postgres'
  not_if "psql -c '\\du' | grep database_user"
end

execute "createdb roux" do
  user 'database_user'
  not_if "psql --dbname=roux"
end