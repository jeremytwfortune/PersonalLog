Get-Item $PSScriptRoot\*\*.ps1 | %{
	. $_.FullName
}

Export-ModuleMember -Function * -Cmdlet *
