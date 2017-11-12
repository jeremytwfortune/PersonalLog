class PersonalLog {
	[Guid] $Id
	[String] $Entry
	[String[]] $Tags
	[DateTime] $Time
	[String] $Location

	PersonalLog() {
		$this.Id = ( New-Guid ).Guid
		$this.Time = Get-Date
	}
}
