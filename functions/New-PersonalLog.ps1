function New-PersonalLog {
	[CmdletBinding(
		DefaultParameterSetName = "Property" )] param (
		[Parameter(
			ParameterSetName = "Property",
			ValueFromPipeLine,
			Position = 1 )]
		[String] $Entry,

		[Parameter(
			ParameterSetName = "Property",
			Position = 2 )]
		[String[]] $Tags,

		[Parameter( ParameterSetName = "Property" )]
		[Guid] $Id,

		[Parameter( ParameterSetName = "Property" )]
		[DateTime] $Time,

		[Parameter( ParameterSetName = "Property" )]
		[String] $Location,

		[Parameter(
			Mandatory,
			ParameterSetName = "Json" )]
		[String] $Json,

		[Parameter( ParameterSetName = "Json" )]
		[Switch] $Utc
	)

	if ( $PSCmdLet.ParameterSetName -Eq "Property" ) {
		$log = New-Object PersonalLog
		if ( $Time ) {
			$log.Time = $Time
		}
		if ( $Id ) {
			$log.Id = $Id
		}

		$log.Entry = $Entry
		$log.Tags = $Tags
		$log.Location = $Location
	} else {
		$jsonObject = $Json | ConvertFrom-Json

		$log = New-Object PersonalLog

		$log.Id = $jsonObject.Id
		if ( $Utc ) {
			$log.Time = ( Get-Date $jsonObject.Time ).ToLocalTime()
		} else {
			$log.Time = $jsonObject.Time
		}
		$log.Entry = $jsonObject.Entry
		$log.Tags = $jsonObject.Tags
		$log.Location = $jsonObject.Location
	}

	$log
}
