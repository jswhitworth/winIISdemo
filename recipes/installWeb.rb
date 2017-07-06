#
# Cookbook:: danner
# Recipe:: installWeb
#
# Copyright:: 2017, Trace3, All Rights Reserved.

powershell_script 'Install IIS' do
	code 'Add-WindowsFeature Web-Server'
	guard_interpreter :powershell_script
	not_if "(Get-WindowsFeature -Name Web-Server).Installed"
end

service 'w3svc' do
	action [:enable, :start]
end

template 'c:\inetpub\wwwroot\Default.htm' do
	source 'Default.htm.erb'
end
