Function Get-FolderHash
{
    param ($folder)
    
    Write-Host "Calculating hash of $folder"
    $files = dir $folder -Recurse |? { -not $_.psiscontainer }
    
    $allBytes = new-object System.Collections.Generic.List[byte]
    foreach ($file in $files)
    {
        $allBytes.AddRange([System.IO.File]::ReadAllBytes($file.FullName))
        $allBytes.AddRange([System.Text.Encoding]::UTF8.GetBytes($file.Name))
    }
    $hasher = [System.Security.Cryptography.MD5]::Create()
    $ret = [string]::Join("",$($hasher.ComputeHash($allBytes.ToArray()) | %{"{0:x2}" -f $_}))
    Write-Host "hash of $folder is $ret."
    return $ret
}
Get-FolderHash "C:\Temp"