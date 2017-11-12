function Save-PersonalLog {
	[CmdletBinding()] param (
		[Parameter(Mandatory, ValueFromPipeLine, Position = 1)]
		[PersonalLog] $Log,

		[Parameter(Position = 2)]
		[ValidateNotNullOrEmpty()]
		[String] $Path = $Env:PERSONALLOG_CACHEDIRECTORY
	)

	if ( ! $Path -or ! ( Test-Path $Path ) ) {
		throw 'No backup directory supplied. Set $Env:PERSONALLOG_CACHEDIRECTORY.'
	} else {
		$logPath = "$Path\$($Log.Id).json"
		$Log | ConvertTo-Json > $logPath

		Get-Item $logPath
	}
}
