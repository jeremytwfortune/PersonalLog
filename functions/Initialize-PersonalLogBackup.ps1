function Initialize-PersonalLogBackup {
	[CmdletBinding()] param (
		[Parameter(Mandatory)]
		[String] $ProfileName,

		[String] $Region = $Env:PERSONALLOG_AWSREGION
	)
	if ( ! ( Get-Module AWSPowerShell ) ) {
		Install-Module AWSPowerShell
	}
	Import-Module AWSPowerShell
	Set-AWSCredentials -AccessKey $Env:PERSONALLOG_AWSACCESSKEY -SecretKey $Env:PERSONALLOG_AWSSECRETKEY -StoreAs $ProfileName
	Initialize-AWSDefaults -ProfileName $ProfileName -Region $Region
}
