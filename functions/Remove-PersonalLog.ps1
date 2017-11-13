function Remove-PersonalLog {
	[CmdletBinding()] param (
		[Parameter(
			Mandatory,
			Position = 1)]
		[ValidateNotNullOrEmpty()]
		[Guid] $Id,

		[ValidateNotNullOrEmpty()]
		[String] $Region = $Env:PERSONALLOG_AWSREGION,

		[ValidateNotNullOrEmpty()]
		[String] $TableName = $Env:PERSONALLOG_TABLENAME
	)

	$result = $False
	if ( Test-NetConnection -InformationLevel Quiet ) {
		try {
			$regionEndpoint = [Amazon.RegionEndPoint]::GetBySystemName( $Region )
			$client = New-Object Amazon.DynamoDbv2.AmazonDynamoDbClient( $regionEndpoint )
			$table = [Amazon.DynamoDbv2.DocumentModel.Table]::LoadTable( $client, $TableName )
			$table.DeleteItem( $Id )
			if ( Test-Path "$Env:PERSONALLOG_CACHEDIRECTORY\$( $Log.Id ).json" ) {
				Remove-Item "$Env:PERSONALLOG_CACHEDIRECTORY\$( $Log.Id ).json"
			}
			$result = $True
		} catch {
			$result = $False
		}
	}
	$result
}
