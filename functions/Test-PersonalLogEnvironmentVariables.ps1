function Test-PersonalLogEnvironmentVariables {
	[CmdletBinding()] param()
	$test = $True
	@(
		"PERSONALLOG_LOCATION",
		"PERSONALLOG_AWSACCESSKEY",
		"PERSONALLOG_CACHEDIRECTORY",
		"PERSONALLOG_AWSSECRETKEY",
	 	"PERSONALLOG_AWSREGION",
		"PERSONALLOG_TABLENAME" ) | %{
		$var = $_
		if ( ! ( $value = [environment]::GetEnvironmentVariable( $var ) ) ) {
			Write-Error "$_ not set"
			$test = $False
		} else {
			Write-Verbose "$var = $value"
		}
	}
	@(
		"PERSONALLOG_DEFAULTTAGS",
	 	"PERSONALLOG_TIMEINDEX" ) | %{
		$var = $_
		if ( ! ( $value = [environment]::GetEnvironmentVariable( $var ) ) ) {
			Write-Verbose "$var not set"
		} else {
			Write-Verbose "$var = $value"
		}
	}
	$test
}
