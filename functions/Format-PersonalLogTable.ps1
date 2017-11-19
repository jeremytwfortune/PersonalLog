function Format-PersonalLogTable {
	[CmdletBinding()] param (
		[Parameter(
			Mandatory,
			Position = 1,
			ValueFromPipeline )]
		[PersonalLog[]] $Log
	)
	$sorted = $Log | Sort-Object -Property Time
	$joined = $log | %{
		$end = $log[( $log.IndexOf( $_ ) ) + 1]
		New-Object PSObject -Property @{
			Id = $_.Id
			StartTime = $_.Time
			EndTime = $end.Time
			Tags = $_.Tags
			Location = $_.Location
			Entry = $_.Entry
			TimeSpan = if ( $end.Time ) { $end.Time - $_.Time }
		}
	}
	$joined
}
