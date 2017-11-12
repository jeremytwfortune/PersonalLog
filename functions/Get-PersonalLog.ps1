function Get-PersonalLog {
	[CmdletBinding()] param (
		[Parameter(
			Mandatory,
			ValueFromPipelineByPropertyName,
			ParameterSetName = "Id" )]
		[String] $Id,

		[Parameter(
			Mandatory,
			ParameterSetName = "Time" )]
		[DateTime] $StartTime,
		[Parameter(
			ParameterSetName = "Time" )]
		[DateTime] $EndTime = (Get-Date),
		[Parameter(
			ParameterSetName = "Time" )]
		[String[]] $Tags,

		[ValidateNotNullOrEmpty()]
		[String] $Region = $Env:PERSONALLOG_AWSREGION,

		[ValidateNotNullOrEmpty()]
		[String] $TableName = $Env:PERSONALLOG_TABLENAME,

		[ValidateNotNullOrEmpty()]
		[String] $TimeIndex = $Env:PERSONALLOG_TIMEINDEX
	)

	function Get-PersonalLogFromBackup {
		Import-Module AWSPowerShell

		$regionEndpoint = [Amazon.RegionEndPoint]::GetBySystemName( $Region )
		$client = New-Object Amazon.DynamoDbv2.AmazonDynamoDbClient( $regionEndpoint )
		$table = [Amazon.DynamoDbv2.DocumentModel.Table]::LoadTable( $client, $TableName )

		$dynamoLogs = @()
		if ( $PSCmdlet.ParameterSetName -Eq "Id" ) {
			$result = $table.GetItem( $Id )
			$dynamoLogs += $result.Items
		} else {
			$filter = New-Object Amazon.DynamoDbv2.DocumentModel.ScanFilter

			$filter.AddCondition(
				"Time",
				[Amazon.DynamoDbv2.DocumentModel.ScanOperator]::Between,
				( ConvertTo-UtcString $StartTime ),
				( ConvertTo-UtcString $EndTime ) )

			foreach ( $tag in $Tags ) {
				$filter.AddCondition(
					"Tags",
					[Amazon.DynamoDbv2.DocumentModel.ScanOperator]::Contains,
					$tag )
			}
			$result = $table.Scan( $filter )
			$dynamoLogs += $result.GetRemaining()
		}
		$logs = @()
		$dynamoLogs | % {
			$logs += New-PersonalLog -Json "$( $_.ToJson() )" -Utc
		}
		$logs
	}

	function Get-PersonalLogFromCache {
		$unfilteredLogs = @()
		Get-ChildItem -Path $Env:PERSONALLOG_CACHEDIRECTORY -Filter "*.json" | %{
			$unfilteredLogs += New-PersonalLog -Json "$( Get-Content -Path $_.FullName )" -Utc
		}

		$logs = @()
		if ( $PSCmdLet.ParameterSetName -Eq "Id" ){
			$logs += $unfilteredLogs | ? {
				$_.Id -Eq $Id
			}
		} else {
			$logs += $unfilteredLogs | ? {
				$_.Time -gt ( $StartTime ) `
				-and $_.Time -lt ( $EndTime ) `
			}
			foreach ( $tag in $Tags ) {
				$logs = $logs | ? { $_.Tags -Contains $tag }
			}
		}
		$logs
	}

	function ConvertTo-UtcString {
		param(
			[DateTime] $Time
		)
		Get-Date $Time.ToUniversalTime() -Format u
	}

	$logs = @()
	if ( Test-NetConnection -InformationLevel Quiet ) {
		$logs += Get-PersonalLogFromBackup
	}

	$logs += Get-PersonalLogFromCache

	$logs
}
