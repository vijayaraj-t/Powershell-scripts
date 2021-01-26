<#

This powershell script will let you retrieve all the site and subsites in your tenant.

-You need a admin credential to run the script
-Run the Script as administrator

Dependencies:
You need this module Microsoft.Online.Sharepoint.Powershell to connect to tenant
You also need Microsoft.Sharepoint.Client.dll and Microsoft.Sharepoint.Client.Runtime.dll.

#>




Add-Type -Path "C:\Program Files\Common Files\microsoft shared\Web Server Extensions\16\ISAPI\Microsoft.Sharepoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\microsoft shared\Web Server Extensions\16\ISAPI\Microsoft.Sharepoint.Client.Runtime.dll"

$credential=Get-Credential

Connect-SPOService -url "Enter your Tenant URL" -credential $credential  #Make connection to tenant

$sites=Get-SPOSite #get all the site collections

Add-Content -Path 'D:\sites.csv' -Value "Site URL's"

function get-subsites($site) #function that will get sitecollection URL as input and will retrieve all subsites recursively.
{
try
{
$ctx=New-object Microsoft.SharePoint.Client.ClientContext($site)
$ctx.Credentials=New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($credential.username,$credential.Password)
$web=$ctx.Web.webs
$ctx.Load($web)
$ctx.ExecuteQuery();
}
catch
{
write-host -f Red "Error:" $_.Exception.Message
}
try
{
foreach($we in $web)
{
Add-Content -Path 'D:\sites.csv' -Value $we.url  |writing to excel file
write-host ($we.url)
get-subsites($we.url) #Recursive call to get all the subsites
}
}
catch
{
write-host -f Red "Error:" $_.Exception.Message
}
}

foreach($site in $sites)
{
Add-Content -Path 'D:\sites.csv' -Value $site.Url
get-subsites($site.Url) #Call to function get-subsites for subsites in site collection
}
