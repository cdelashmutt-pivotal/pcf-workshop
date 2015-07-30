<#
    .SYNOPSIS 
      Creates a set of CF organizations and users based on an input file.
    .EXAMPLE
     Get-WmiClasses -class disk -ns root\cimv2"
     This command finds wmi classes that contain the word disk. The 
     classes returned are from the root\cimv2 namespace.
#>

param(
    [switch]$NoBindSecurityGroup,
    [string]$EmailFile = "class-participant-emails.txt",
    [switch]$UseEntireEmail
)

Foreach ($email in gc $EmailFile){

    Write-Host "Processing $email"
    if($UseEntireEmail)
    {
        $split = $email.Split("@")[0]
        $org = $split + '-org'
    }
    else
    {
        $split = $email.Split('_')
        $substring = $split.Substring(0,1)
        $org = $substring + '-org'
    }
    Write-Host "INFO: Setting up $($org): for $($email)"
    cf create-org $org
    cf create-space development -o $org
    cf create-space production -o $org
    cf create-user $email password
	
    cf set-org-role admin $org OrgManager
    cf set-org-role $email $org OrgManager
    cf set-space-role $email $org development SpaceManager
    cf set-space-role $email $org development SpaceDeveloper
    cf set-space-role $email $org production SpaceManager
    cf set-space-role $email $org production SpaceDeveloper
    if( -Not $NoBindSecurityGroup ) {
        cf bind-security-group all_open $org production
    }
}