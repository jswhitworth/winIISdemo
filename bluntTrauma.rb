#
# Cookbook Name:: bluntTrauma
# Recipe:: default
# Author(s):: T Danner
# Copyright:: 2017 Trace3, Inc.

# Voices Scream, Nothings Seen, Reals a Dream
#                             - S. Tyler 


# Configures Windows Update automatic updates
# NEVER ERVER use this in prod, as there's no coordination with other pipeline processes nor
# coordination  with security controls.

# Basicly, this is a blunt powershell script using native commandlet to patch up a system, all rolled up
# into a chef script

powershell_script "install-windows-updates" do
  guard_interpreter :powershell_script
  # Set a 2 hour timeout
  timeout 7200
  code <<-EOH
    Write-Host -ForegroundColor Green "Searching for updates (this may take up to 30 minutes or more)..."

    $updateSession = New-Object -com Microsoft.Update.Session
    $updateSearcher = $updateSession.CreateupdateSearcher()
    try
    {
      $searchResult =  $updateSearcher.Search("Type='Software' and IsHidden=0 and IsInstalled=0").Updates
    }
    catch
    {
      eventcreate /t ERROR /ID 1 /L APPLICATION /SO "Chef-Cookbook" /D "InstallWindowsUpdates: Update attempt failed."
      $updateFailed = $true
    }

    if(!($updateFailed)) {
      foreach ($updateItem in $searchResult) {
        $UpdatesToDownload = New-Object -com Microsoft.Update.UpdateColl
        if (!($updateItem.EulaAccepted)) {
          $updateItem.AcceptEula()
        }
        $UpdatesToDownload.Add($updateItem)
        $Downloader = $UpdateSession.CreateUpdateDownloader()
        $Downloader.Updates = $UpdatesToDownload
        $Downloader.Download()
        $UpdatesToInstall = New-Object -com Microsoft.Update.UpdateColl
        $UpdatesToInstall.Add($updateItem)
        $Title = $updateItem.Title
        Write-host -ForegroundColor Green "  Installing Update: $Title"
        $Installer = $UpdateSession.CreateUpdateInstaller()
        $Installer.Updates = $UpdatesToInstall
        $InstallationResult = $Installer.Install()
        eventcreate /t INFORMATION /ID 1 /L APPLICATION /SO "Chef-Cookbook" /D "InstallWindowsUpdates: Installed update $Title."
      }

      if (!($searchResult.Count)) {
        eventcreate /t INFORMATION /ID 999 /L APPLICATION /SO "Chef-Cookbook" /D "InstallWindowsUpdates: No updates available."
      }
      eventcreate /t INFORMATION /ID 1 /L APPLICATION /SO "Chef-Cookbook" /D "InstallWindowsUpdates: Done Installing Updates."
    }
  EOH
  action :run
end