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
  action :create
end

iis_site 'Testfu Site' do
  protocol :http
  port 80
  path "#{node['iis']['docroot']}/icon"
  action [:add,:start]
end