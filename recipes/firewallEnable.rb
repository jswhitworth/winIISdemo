#
# Cookbook:: danner
# Recipe:: firewallEnable
# Author: danner
#
# Copyright:: 2017, Trace3, All Rights Reserved.
# Downloads and a


include_recipe "windows_firewall"

windows_firewall_rule 'Apache' do
		localport '80'
		protocol 'TCP'
		firewall_action :allow	
end