$autopatchFiles = Get-Content -Path ./autopatchFiles.txt
Set-Location ./9Data/Shine

$preUpdateHash=(git rev-parse --short HEAD)
git pull

$modifiedFiles=(git diff --name-only $preUpdateHash HEAD)
if ($null -ne $modifiedFiles) {
	$fileArray = $modifiedFiles.Split(" ")
}

$destinationRootPath = "C:\inetpub\wwwroot\"
$destinationSourcePath = $destinationRootPath + "patches\"
$ressystem = $destinationSourcePath + "ressystem\"

Get-ChildItem -Path $ressystem -Include * -File -Recurse | ForEach-Object { $_.Delete()}

foreach ($file in $fileArray)
{
	$filename = Split-Path -Path $file -Leaf
	if ($autopatchFiles.Contains($filename)){
		$filepath = (Get-ChildItem $file -Recurse)
		Write-Host($filepath)
		$destinationFilePath = $ressystem + $file
		Write-Host $file.Name
		$destinationFilePath = $destinationFilePath -replace "\\View", ""
		Copy-Item -Path $filepath -Destination $destinationFilePath
	} else {
		Write-Host ("not included" + $file)
	}
}

if ($null -ne (Get-ChildItem -Path $ressystem)){
	$currentPatchVersion = ((Get-ChildItem -Path $destinationSourcePath*.zip).Count)
	$newPatchVersion = $currentPatchVersion + 1
	$newZipPath= "patch"+$newPatchVersion+".zip"
	
	Write-Host ("New Version: " + $newPatchVersion)
	
	Compress-Archive -Path $ressystem -DestinationPath ($destinationSourcePath + $newZipPath)
	
	$config = $destinationRootPath + "Config.ini"
	$patchCurrent = "PatchVersion=" + $currentPatchVersion
	$patchNew = "PatchVersion=" + $newPatchVersion
	
	(Get-Content $config) -replace $patchCurrent, $patchNew | Set-Content $config
}