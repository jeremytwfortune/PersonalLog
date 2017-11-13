function Update-PersonalLog {
	[CmdletBinding()] param (
		[Parameter(
			Mandatory,
			ValueFromPipeLine,
			Position = 1)]
		[ValidateNotNullOrEmpty()]
		[PersonalLog] $Log,

		[ValidateNotNullOrEmpty()]
		[String] $Region = $Env:PERSONALLOG_AWSREGION,

		[ValidateNotNullOrEmpty()]
		[String] $TableName = $Env:PERSONALLOG_TABLENAME
	)

	if ( Remove-PersonalLog -Id $Log.Id ) {
		Write-PersonalLog `
			-Id $Log.Id `
			-Entry $Log.Entry `
			-Time $Log.Time `
			-Location $Log.Location `
			-Tags $Log.Tags `
			-IgnoreDefaultTags
	} else {
		Write-Error "Unable to update item."
	}
}
