
#Retrieve flavors 
$Flavors = Get-OpenStackComputeServerFlavor -Account rackORD | Select-Object Name, ID

#Retrieve just Windows images and IDs
$Image = Get-OpenStackComputeServerImage -Account rackORD | Select-Object Name, ID | Where {$_.Name -like "Windows*"}


    #Create Hashtable of Images and number the list 
$Num = 0
$Winimages = @()
foreach ($img in $Image) 

            {
                
                $item = New-Object PSObject
                $item | Add-Member -MemberType NoteProperty -Name "Number" -Value $Num
                $item | Add-Member -MemberType NoteProperty -Name "Image ID" -Value $img.Id
                $item | Add-Member -MemberType NoteProperty -Name "Image Name" -Value $img.Name
                $Winimages +=$item
                $Num += 1

            }

$Winimages | ft



$ImgNum = Read-Host "Enter number of Image you would like to use"
$Userimg = $Winimages[$ImgNum]
$Buildimg = $Userimg.'Image ID'
$ImgName = $Userimg.'Image Name'


#Create a hashtable of flavors, adding numbers to each item 
$FlvNum = 0
$WinFlavors = @()
foreach ($Flv in $Flavors) 
         {    
                $item2 = New-Object PSObject
                $item2 | Add-Member -MemberType NoteProperty -Name "Flavor Number" -Value $FlvNum
                $item2 | Add-Member -MemberType NoteProperty -Name "Flavor ID" -Value $Flv.Id
                $item2 | Add-Member -MemberType NoteProperty -Name "Flavor Name" -Value $Flv.Name
                $WinFlavors += $item2
                $FLvNum += 1
         }
          

     
$WinFlavors | ft

$FlvNum = Read-Host "Enter number of Flavour you would like to use"
$UserFlv = $WinFlavors[$FlvNum]
$BuildFlv = $UserFlv.'Flavor ID'
$Flvname = $UserFlv.'Flavor Name'

$SrvName = Read-Host "Enter server Name"

Write-Host "`n"
Write-Host "You have chosen to build a server called: $SrvName `n" -ForegroundColor Yellow
Write-Host "Image name: $ImgName `n" -ForegroundColor Yellow
Write-Host "Flavour: $Flvname " -ForegroundColor Yellow


if (-not $force) {
    if((Read-Host "Warning, this script is about to create the server do you want to proceeed (Y/N)") -notlike "y*") {exit} }

#Create new server using details provided
New-OpenStackComputeServer -Account rackOrd -ServerName $SrvName -ImageId $BuildImg -FlavorId $BuildFlv


Write-Host "Building Server " -ForegroundColor Green