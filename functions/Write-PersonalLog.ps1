function Write-PersonalLog {
	[CmdletBinding()] param (
		[Parameter(ValueFromPipeLine, Position = 1)]
		[String] $Entry,

		[Parameter(Position = 2)]
		[String[]] $Tags,

		[DateTime] $Time,

		[String] $Location = $Env:PERSONALLOG_LOCATION,

		[ValidateNotNullOrEmpty()]
		[String] $Path = $Env:PERSONALLOG_CACHEDIRECTORY,

		[Switch] $IgnoreDefaultTags
	)

	if ( ! ( Test-PersonalLogCacheIsEmpty ) ) {
		Write-Warning "There are cached logs in '$Env:PERSONALLOG_CACHEDIRECTORY'. Run Backup-PersonalLog to save them."
	}

	if ( ! ( $IgnoreDefaultTags ) -And $Env:PERSONALLOG_DEFAULTTAGS ) {
		$Env:PERSONALLOG_DEFAULTTAGS -Split " " | %{
			$Tags = $Tags + $_
		}
	}
	$newLogParameters = @{}
	if ( $Entry ) { $newLogParameters.Entry = $Entry }
	if ( $Tags ) { $newLogParameters.Tags = $Tags }
	if ( $Time ) { $newLogParameters.Time = $Time }
	if ( $Location ) { $newLogParameters.Location = $Location }

	$saveLogParameters = @{}
	if ( $Path ) { $saveLogParameters.Path = $Path }

	$log = New-PersonalLog @newLogParameters
	$file = $log | Save-PersonalLog @saveLogParameters
	$backupResult = $log | Backup-PersonalLog
	if ( $backupResult ) {
		Remove-Item $file
	}

	@{ File = $file; BackupResult = $backupResult; Log = $log }
}
