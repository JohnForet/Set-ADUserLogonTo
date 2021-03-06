@{

# Script module or binary module file associated with this manifest.
RootModule = '.\Set-ADUserLogonTo.psm1'

# Version number of this module.
ModuleVersion = '1.0.3'

# ID used to uniquely identify this module
GUID = 'ec213ba3-c283-4246-ab11-f432999fbda7'

# Author of this module
Author = 'John Foret'

# Company or vendor of this module
CompanyName = 'John Foret'

# Copyright statement for this module
Copyright = '(c) 2016 John Foret. All rights reserved.'

# Description of the functionality provided by this module
Description = 'PowerShell module designed to make it easier to change the userWorkstations attribute on AD users'

# Format files (.ps1xml) to be loaded when importing this module
FormatsToProcess = '.\Set-ADUserLogonTo.format.ps1xml'

# Functions to export from this module
FunctionsToExport = 'Get-ADUserLogonTo','Set-ADUserLogonTo'

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = @('AD', 'ActiveDirectory', 'userWorkstations', 'LogonTo')

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/JohnForet/Set-ADUserLogonTo'

    } # End of PSData hashtable

} # End of PrivateData hashtable

}

