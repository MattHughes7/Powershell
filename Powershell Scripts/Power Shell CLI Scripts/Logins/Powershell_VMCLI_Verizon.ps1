# Adds the base cmdlets
Add-PSSnapin VMware.VimAutomation.Core
# Add the following if you want to do things with Update Manager
Add-PSSnapin VMware.VumAutomation
# This script adds some helper functions and sets the appearance. You can pick and choose parts of this file for a fully custom appearance.
. "C:\Program Files (x86)\VMware\Infrastructure\vSphere PowerCLI\Scripts\Initialize-PowerCLIEnvironment.ps1"

Connect-VIServer hfvcs02 -User mhughescolo -Password T3kN1nj@ -SaveCredentials