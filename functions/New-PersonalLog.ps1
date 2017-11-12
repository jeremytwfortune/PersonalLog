function New-PersonalLog {
	param (
		[Parameter(ValueFromPipeLine, Position = 1)]
		[String] $Entry,

		[Parameter(Position = 2)]
		[String[]] $Tags,

		[DateTime] $Time,
		[String] $Location
	)

	if ( $Time ) {
		$log = New-Object PersonalLog( $Time )
	} else {
		$log = New-Object PersonalLog
	}

	$log.Entry = $Entry
	$log.Tags = $Tags
	$log.Location = $Location

	$log
}
