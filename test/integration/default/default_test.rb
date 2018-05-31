# # encoding: utf-8

# Inspec test for recipe mydatabase::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe package('postgresql') do
  it { should be_installed }
end

describe port('5432') do
  its('processes') { should include 'postgres' }
end

# describe file('/etc/postgresql/9.5/main/pg_hba.conf') do
#   its('content') { should match 'database_user' }
# end

describe command("psql roux -c '\\conninfo'") do
	its(:stdout) { should match 'connected' }
end

sql = postgres_session('database_user', 'user_password', 'localhost')
describe sql.query('\conninfo', ['roux']) do
  its('output') { should match 'connected' }
end

