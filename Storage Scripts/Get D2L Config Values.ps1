#User variables (these can be changed)
$outputToCSV = $true

#Define some variables
$datetime = [DateTime]::Now
$resultsCSV = ""
$errorList = ""
$scriptDirectory = "I:"

#Clear the screen
Clear-Host

#Define our SQL Instance
$instances = @(
#	"SQL17",
#	"SQL19",
#	"SQL21",
#	"SQL23",
#	"SQL25",
#	"SQL10",
#	"SQL27A\INSTANCEA",
#	"SQL27B\INSTANCEB",
#	"SQL29",
	"T1SQL25A\INSTANCEA",
	"T1SQL26A\INSTANCEA",
	"T1SQL27A\INSTANCEA",
	"T1SQL28A\INSTANCEA",
	"T1SQL29A\INSTANCEA",
	"T1SQL29B\INSTANCEB",
	"T1SQL01A\INSTANCEA",
	"T1SQL30A\INSTANCEA",
	"T1SQL31A\INSTANCEA"
	)

#$instances = @(
#	"T1SQL25A\INSTANCEA"
#	)

foreach ($instance in $instances)
{
	Write-Host $instance
	#Write our SQL query
	$query = "
	
SET NOCOUNT ON

--define some variables
DECLARE @SQL		VARCHAR(MAX)
DECLARE @Database	VARCHAR(64)

--recreate the temp tables
IF (OBJECT_ID('tempdb..##KFoxConfigs') IS NOT NULL) DROP TABLE ##KFoxConfigs
CREATE TABLE ##KFoxConfigs (DBName VARCHAR(64), Name VARCHAR(50), ConfigId INT, Val NVARCHAR(MAX))
IF (OBJECT_ID('tempdb..##KFoxVariables') IS NOT NULL) DROP TABLE ##KFoxVariables
CREATE TABLE ##KFoxVariables (DBName VARCHAR(64), VarId INT, OrgId INT, Value NVARCHAR(1000))

--get the first database
SET @Database = (SELECT TOP(1) name FROM sys.databases WHERE database_id > 4 ORDER BY name)

--loop through the databases
WHILE @Database IS NOT NULL
BEGIN
	--create the command to get the config and variable values
	SET @SQL = '' +
		'USE [' + @Database + ']; ' +
		'IF OBJECT_ID(''dbo.CONFIG_SYSTEM_VALUES'') IS NOT NULL ' +
		'BEGIN ' +
		'	INSERT INTO ##KFoxConfigs ' +
		'	SELECT ''' + @Database + ''', Name, ConfigId, Val FROM dbo.CONFIG_SYSTEM_VALUES WITH(NOLOCK) ' +
		'	WHERE Val LIKE ''%\\%'' ' +	
		'	ORDER BY Name ' +
		'END ' +
		'IF OBJECT_ID(''dbo.VARIABLES'') IS NOT NULL ' +
		'BEGIN ' +
		'	INSERT INTO ##KFoxVariables ' +
		'	SELECT ''' + @Database + ''', VarId, OrgId, Value FROM dbo.VARIABLES WITH (NOLOCK) ' +
		'	WHERE Value LIKE ''%\\%'' ' +
		'END '
	EXEC(@SQL)
	--get the next database
	SET @Database = (SELECT TOP(1) name FROM sys.databases WHERE database_id > 4 AND name > @Database ORDER BY name)
END

--show the table
SELECT * FROM ##KFoxConfigs
--SELECT * FROM ##KFoxVariables

--drop the temp table
DROP TABLE ##KFoxConfigs
DROP TABLE ##KFoxVariables
	"
	
	#Run our query
	$results = ""
	try { $results = Invoke-Sqlcmd -Query $query -ServerInstance $instance -ConnectionTimeout 60 }
	catch { $errorList += "Could not connect to instance " + $instance + [Environment]::NewLine }
	#Go through the databases on this instance
	foreach ($row in $results)
	{
		$resultsCSV += $instance + "," + $row.get_Item(0) + "," + $row.get_Item(1) + "," + $row.get_Item(2) + "," + $row.get_Item(3) + [Environment]::NewLine
	}
}

#Write to a CSV file if the user wanted that
if ($outputToCSV)
{
	#Create the stream
	$stream = [System.IO.StreamWriter] ($scriptDirectory + "\Output.csv")
	#$stream.WriteLine("Instance, DBName, Name, ConfigId, Value")
	$stream.WriteLine("Instance, DBName, VarId, OrgId, Value")
	$stream.WriteLine($resultsCSV)
	#Close the stream
	$stream.close()
}


#'	WHERE ((VarId = 10002 AND OrgId <> 0) OR (VarId = 10005 AND OrgId <> 0) OR (VarId = 10006 AND OrgId <> 0)) ' +