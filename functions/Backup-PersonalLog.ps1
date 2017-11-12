function Backup-PersonalLog {
	[CmdletBinding(
		DefaultParameterSetName = "Directory"
	)]
	param (
		[Parameter(
			Mandatory,
			ValueFromPipeline,
			Position = 1,
			ParameterSetName = "Single")]
		[PersonalLog] $Log,

		[Parameter(
			Position = 1,
			ParameterSetName = "Directory")]
		[String] $Path = $Env:PERSONALLOG_CACHEDIRECTORY,

		[ValidateNotNullOrEmpty()]
		[String] $Region = $Env:PERSONALLOG_AWSREGION,

		[ValidateNotNullOrEmpty()]
		[String] $TableName = $Env:PERSONALLOG_TABLENAME
	)

	$ProgressPreference = "SilentlyContinue"
	if ( ! ( Test-NetConnection -InformationLevel Quiet ) ) {
		Write-Warning "Unable to establish a connection"
		return
	}

	Import-Module AWSPowerShell

	$regionEndpoint = [Amazon.RegionEndPoint]::GetBySystemName( $Region )
	$client = New-Object Amazon.DynamoDbv2.AmazonDynamoDbClient( $regionEndpoint )
	$table = [Amazon.DynamoDbv2.DocumentModel.Table]::LoadTable( $client, $TableName )

	$cachedLogs = @()
	if ( $PSCmdlet.ParameterSetName -eq "Single" ) {
		$pipelineLog = $Log | ConvertTo-Json | ConvertFrom-Json  # Stringifying. We need to do JSON conversions anyway.
		$pipelineLog.Time = Get-Date $Log.Time.ToUniversalTime() -Format u
		$cachedLogs += $pipelineLog
	} else {
		Get-ChildItem -Path $Path -Filter "*.json" | %{
			$fileLog = Get-Content $_.FullName | ConvertFrom-Json
			$fileLog.Time = Get-Date $fileLog.Time.ToUniversalTime() -Format u
			$cachedLogs += $fileLog
		}
	}

	foreach ( $cachedLog in $cachedLogs ) {
		$document = [Amazon.DynamoDbv2.DocumentModel.Document]::FromJson( ( $cachedLog | ConvertTo-Json ) )
		$table.PutItem( $document )
	}

	$savedDocuments = @()
	foreach ( $cachedLog in $cachedLogs ) {
		$result = $table.GetItem( $cachedLog.Id )
		if ( $result.Count -gt 0 ) {
			$savedDocuments += $cachedLog
			if ( $PSCmdLet.ParameterSetName -eq "Directory" ) {
				Remove-Item -Path "$Path\$($cachedLog.Id).json"
			}
		} else {
			Write-Warning "Unable to backup log with ID '$($cachedLog.Id)'"
		}
	}
	$savedDocuments
}
