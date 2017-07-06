#
# Cookbook:: danner
# Recipe:: siteCreate
# Author: danner
#
# Copyright:: 2017, Trace3, All Rights Reserved.
# Downloads and a


include_recipe "iis"

iis_site 'Default Web Site' do
  action [:stop, :delete]
end

 
directory "#{node['iis']['docroot']}/icon" do
	recursive true
	action :delete
end

remote_directory "feather" do
	path "#{node['iis']['docroot']}/icon"
	action :create
end




#git "#{node['iis']['docroot']}/iconn" do
#	repository "https://github.com/colebemis/feather.git"
#	reference "master"
#	action :sync
#end


iis_site 'Testfu Site' do
  protocol :http
  port 80
  path "#{node['iis']['docroot']}/icon"
  action [:add,:start]
end