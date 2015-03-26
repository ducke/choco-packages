function Get-ReachedEndByte
{
[CmdletBinding()]
param
  (
    $fs,
    [byte]$endByte,
    [byte]$readValue
  )
  if ($endByte -eq $readValue)
  {
      return $true
  }
            
  if ($fs.Length -eq $fs.Position)
  {
    #prevent infinite loops because the end of the file has been reached
    #but the 'end byte' hasn't been detected.
    throw 'Premature end of file.'
    return $false
  }
}

function SkipField
{
  [CmdletBinding()]
  param
  (
    $fs,
    [byte]$flag
  )
  #if it's not an 'identifier byte' skip the
  #skip the unknown data
  if (!($flag -ge '0x80' -and $flag -le '0x9F'))
  {
    [byte]$tempBytes = [byte]'4'

    $fs.Read($tempBytes, 0, 4);

    #skip the number of bytes
    $fs.Position += [System.BitConverter]::ToInt32($tempBytes, 0)
  }
}
$path = 'C:\temp\markdownresponse\0'
$mode = [System.IO.FileMode]::Open
$access = [System.IO.FileAccess]::Read

# create the FileStream and StreamWriter objects
$fs = New-Object IO.FileStream($path, $mode, $access)

$btype = $fs.ReadByte()
while (-not (Get-ReachedEndByte -fs $fs -endbyte $btype -readvalue '0xFF'))
{
  Write-Verbose ('{0}' -f $btype)
  switch ($btype)
  {
  [byte]'0x01' {break}
  #Read New Version
  #serv.NewVersion = ReadFiles.ReadDeprecatedString(fs);
  Default {
    SkipField -fs $fs -flag $btype
    break
    }
  }
}