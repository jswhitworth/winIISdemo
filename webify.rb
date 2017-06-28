
#
# Cookbook Name:: webify
# Recipe:: default
# Author(s):: T Danner
# Copyright:: 2017 Trace3, Inc.


windows_feature 'IIS-WebServerRole' do
	action :install
end
