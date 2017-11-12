# Personal Log

Powershell Cmdlets for recording everyday activities and saving them to AWS DynamoDB, because answering "what'd you do last week?" is far more difficult than it should be. PersonalLog is the functional equivalent of scribbling something down, if someone came along and copied your scribbles across multiple AWS regions. Implements a local cache for those occasional times you're not net-connected.

## Usage

### Writing Logs

Designed to be dead simple and get out of your way.

```PowerShell
Write-PersonalLog "Starting on a new project"
```

Or tag your entry:

```PowerShell
Write-PersonalLog "Starting on another project" "Work", "Project2"
```

Don't forget to set some simple alias. If you don't like your defaults, including the time the log is written, just spsecify the override as an argument.

```PowerShell
l -Entry "Studying how to make decent curry" -Tags "Food" -Time (Get-Date).AddDays(-1) -Location "Redacted"
```

Or just check in.

```PowerShell
l
```

## Installation

- Clone the repo.
- Set up a new DynamoDB table and get an AWS IAM access/secret key pair. This should take about 2 minutes.
- Set the following environment variables (probably in `$PROFILE`)

| Variable | Purpose |
| -------- | ------- |
| `PERSONALLOG_LOCATION` | Identifiable machine address. Stored as metadata of the entry. |
| `PERSONALLOG_CACHEDIRECTORY` | Local path to cache logs in case backup to AWS fails. |
| `PERSONALLOG_AWSACCESSKEY` | AWS IAM access key. |
| `PERSONALLOG_AWSSECRETKEY` | AWS IAM secret key. |
| `PERSONALLOG_AWSREGION` | AWS region name where your DynamoDB log is stored. |
| `PERSONALLOG_TABLENAME` | AWS DynamoDB table name. |
| `PERSONALLOG_DEFAULTTAGS` | Default tags to add to each log entry. These will be appended to any command line tags. |

- Edit your `$PROFILE` to point to the repo and import the module with `Import-Module Path\To\Repo\PersonalLog.psm1`
- Run `Initialize-PersonalLogBackup`
