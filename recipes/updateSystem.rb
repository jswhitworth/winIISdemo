#
# Cookbook:: danner
# Recipe:: updateSystem
# Author: danner
#
# Copyright:: 2017, Trace3, All Rights Reserved.
# Downloads and applies system updates from redmond - never run this in prod!!


powershell_script "install-windows-updates" do 
	guard_interpreter :powershell_script

	#timeout after one hour
	timeout 3600
	code <<-EOH
		Write-host "Updating system.... go get some coffee"
		Write-host "Checking w Redomond for updates"

		$updateSession = New-Object -com Microsoft.Update.Session
		$updateSearcher = $updateSession.createUpdateSearcher()

		try {
			$searchresult = $updateSearcher.Search("Type='Software' and IsHidden=0 and IsInstalled=0").Updates
			$updateFailed = $false
		} catch {
			# Let the user known, this is to be done
			$updateFailed = $true
		}

		# if we're ok to this point loop thru the updates and apply
		if (!($updatedFailed)) {
			"update status check worked"


		foreach ($updateItem in $searchResult) {
				$UpdatesToDownload = New-Object -com Microsoft.Update.UpdateColl
				if (!($updateItem.EulaAccepted)) {
					$updateItem.AcceptEula()
				}
				$UpdatesToDownload.Add($updateItem)

				# grab the download from MS
				$Downloader = $UpdateSession.CreateUpdateDownloader()
				$Downloader.Updates = $UpdatesToDownload
				$Downloader.Download()


				$UpdatesToInstall = New-Object -com Microsoft.Update.UpdateColl
				$UpdatesToInstall.Add($updateItem)
				
				$Installer = $updateSession.CreateUpdateInstaller()
				$Installer.Updates = $UpdatesToInstall
				$InstallationResult = $Installer.Install()

			}

			if (!($searchResult.count)) {
				"No new updates"	
			}
			"All done - updated best I can!"
		}

	EOH
	action :run
end
