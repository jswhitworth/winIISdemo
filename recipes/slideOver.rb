#
# Cookbook:: danner
# Recipe:: siteCreate
# Author: danner
#
# Copyright:: 2017, Trace3, All Rights Reserved.
# Downloads and a

 
directory "#{node['iis']['docroot']}/icon" do
	action :delete
end

git "#{node['iis']['docroot']}/iconn" do
	repository "https://github.com/colebemis/feather.git"
	reference "master"
	action :sync
end
