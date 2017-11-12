function Test-PersonalLogCacheIsEmpty {
	[CmdletBinding()] param()

	$test = $True
	if ( Test-PersonalLogEnvironmentVariables ) {
		$unsavedLogs = Get-ChildItem -Path $Env:PERSONALLOG_CACHEDIRECTORY -Filter "*.json"
		if ( $unsavedLogs.Count -gt 0 ) {
			$test = $False
		}
	} else {
		$test = $False
	}
	$test
}
