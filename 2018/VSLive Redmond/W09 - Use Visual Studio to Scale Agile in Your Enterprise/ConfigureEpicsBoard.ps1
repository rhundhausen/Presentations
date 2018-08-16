function Main
{
  cls
  $VstsAccount = "https://<your account>.visualstudio.com"
  $VstsToken = "<your personal access token>"
  $VstsTeamProject = "<your team project>"

  # Uncomment the following line if necessary
  # Set-ExecutionPolicy Unrestricted

  # Don't change anything below here, unless you want to improve the code (example: https://www.powershellgallery.com/packages/VSTeam/2.1.13)

  $basicAuth = ("{0}:{1}" -f "",$VstsToken)
  $basicAuth = [System.Text.Encoding]::UTF8.GetBytes($basicAuth)
  $basicAuth = [System.Convert]::ToBase64String($basicAuth)
  $headers = @{Authorization=("Basic {0}" -f $basicAuth)}

  Write-Host $VstsAccount"/"$VstsTeamProject
  Write-Host

  Write-Host "Setting Epic board columns" -NoNewline
  ConfigureEpicBoardColumns
  ListBoardColumns "Epics"
   
  Write-Host
  Write-Host "Done"
}

function ConfigureEpicBoardColumns()
{
  # Get first and last column ID

  $columnFirst = ""
  $columnLast = ""
  $resource = $VstsAccount + "/" + $VstsTeamProject + "/" + $VstsTeamProject + '%20Team/_apis/work/boards/Epics/columns?api-version=3.0'
  $response = Invoke-RestMethod -Uri $resource -headers $headers -Method Get
  $response.value | ForEach-Object {
    if (! $columnFirst)
    {
      $columnFirst = $_.id
    }
    $columnLast = $_.id
  }

  # Set board columns

  $resource = $VstsAccount + "/" + $VstsTeamProject + "/" + $VstsTeamProject + '%20Team/_apis/work/boards/Epics/columns?api-version=3.0'
  $json = '[{"id":"' + $columnFirst + '","name":"New","itemLimit":0,"stateMappings":{"Epic":"New"},"columnType":"incoming"},
            {"id":"","name":"Reviewing","itemLimit":0,"stateMappings":{"Epic":"In Progress"},"isSplit":false,"description":"","columnType":"inProgress"},
            {"id":"","name":"Analyzing","itemLimit":0,"stateMappings":{"Epic":"In Progress"},"isSplit":false,"description":"","columnType":"inProgress"},
            {"id":"","name":"Portfolio","itemLimit":0,"stateMappings":{"Epic":"In Progress"},"isSplit":false,"description":"","columnType":"inProgress"},
            {"id":"","name":"Implementing","itemLimit":0,"stateMappings":{"Epic":"In Progress"},"isSplit":false,"description":"","columnType":"inProgress"},
            {"id":"' + $columnLast + '","name":"Done","itemLimit":0,"stateMappings":{"Epic":"Done"},"columnType":"outgoing"}]'

# $json

  try {
    $response = Invoke-RestMethod -Uri $resource -headers $headers -Method Put -Body $json -ContentType 'application/json'
  }
  catch {
    $_.Exception|format-list -force
    return
  }
}

function ListBoardColumns([string]$board,[string]$team)
{
  $columnsHash = ""
  if ($team) {
    $resource = $VstsAccount + "/" + $VstsTeamProject + "/" + $team + '/_apis/work/boards/' + $board + '/columns?api-version=3.0'
  }
  else {
    $resource = $VstsAccount + "/" + $VstsTeamProject + "/" + $VstsTeamProject + '%20Team/_apis/work/boards/' + $board + '/columns?api-version=3.0'
  }

  # $resource

  $response = Invoke-RestMethod -Uri $resource -headers $headers -Method Get
  $response.value | ForEach-Object {
    $columnsHash += $_.name + " (" + $_.itemLimit + "), "
  }
  write-host ":"$columnsHash.Substring(0,$columnsHash.length-2).TrimStart().TrimEnd()
}

Main