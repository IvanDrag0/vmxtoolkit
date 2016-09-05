<<<<<<< HEAD
﻿################## Some Globals 
write-verbose "getting VMware Path from Registry"
if (!(Test-Path "HKCR:\")) { $NewPSDrive = New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT }
if (!($VMWAREpath = Get-ItemProperty HKCR:\Applications\vmware.exe\shell\open\command -ErrorAction SilentlyContinue))
{
	Write-Error "VMware Binaries not found from registry"; Break
}
$Global:vmxdir = split-path $PSScriptRoot
$VMWAREpath = Split-Path $VMWAREpath.'(default)' -Parent
$VMWAREpath = $VMWAREpath -replace '"', ''
$Global:vmwarepath = $VMWAREpath
$Global:vmware = "$VMWAREpath\vmware.exe"
$Global:vmrun = "$VMWAREpath\vmrun.exe"
$vmwarefileinfo = Get-ChildItem $Global:vmware
# if (Test-Path "$env:appdata\vmware\inventory.vmls")
#{
$Global:vmxinventory = "$env:appdata\vmware\inventory.vmls"
#}
# End VMWare Path
=======
﻿[CmdletBinding()]
param
(
$VMX_Path)

################## Some Globals
write-Host "trying to get os type ... "
if  (Test-Path C:\WINDOWS\system32\ntdll.dll)
	{
	$OS_Version  = Get-Command C:\WINDOWS\system32\ntdll.dll
	$OS_Version = "Product Name: Windows $($OS.Version)"
	$Global:vmxtoolkit_type ="win_x86_64"
    write-verbose "getting VMware Path from Registry"
    if (!(Test-Path "HKCR:\")) { $NewPSDrive = New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT }
    if (!($VMware_Path = Get-ItemProperty HKCR:\Applications\vmware.exe\shell\open\command -ErrorAction SilentlyContinue))
        {
	    Write-Error "VMware Binaries not found from registry"
        Break
        }
	$VMX_Basedir ='\Documents\Virtual Machines\'
    $VMware_Path = Split-Path $VMware_Path.'(default)' -Parent
    $VMware_Path = $VMware_Path -replace '"', ''
    $Global:vmwarepath = $VMware_Path
    $Global:vmware = "$VMware_Path\vmware.exe"
    $Global:vmrun = "$VMware_Path\vmrun.exe"
	$Global:vmware_vdiskmanager = Join-Path $VMware_Path 'vmware-vdiskmanager.exe'
	$Global:VMware_OVFTool = Join-Path $Global:vmwarepath 'OVFTool\ovftool.exe'
	$GLobal:VMware_packer = Join-Path $Global:vmwarepath '7za.exe'
    $VMwarefileinfo = Get-ChildItem $Global:vmware
    $Global:vmxinventory = "$env:appdata\vmware\inventory.vmls"
    $Global:vmwareversion = New-Object System.Version($VMwarefileinfo.VersionInfo.ProductMajorPart,$VMwarefileinfo.VersionInfo.ProductMinorPart,$VMwarefileinfo.VersionInfo.ProductBuildPart,$VMwarefileinfo.VersionInfo.ProductVersion.Split("-")[1])
	}
else
	{
	if ($OS = uname)
		{
		Write-Host "found OS $OS"
		Switch ($OS)
			{
			"Darwin"
				{
				$Global:vmxtoolkit_type = "OSX"
				$OS_Version = (sw_vers)
				$OS_Version = $OS_Version -join " "
				$VMX_BasePath = 'Documents/Virtual Machines.localized'
				$VMware_Path = "/Applications/VMware Fusion.app"
				$Global:vmwarepath = $VMware_Path
				$VMware_BIN_Path = Join-Path $VMware_Path  '/Contents/Library'
				$Global:VMware_vdiskmanager = Join-Path $VMware_BIN_Path 'vmware-vdiskmanager'
				$GLobal:VMware_packer = Join-Path '/usr/local/bin/' '7za'
				$Global:vmrun = Join-Path $VMware_BIN_Path "vmrun"
				$Global:VMware_OVFTool = Join-Path $VMware_Path 'ovftool'
				[version]$Global:vmwareversion = "12.0.0.0"
				}
			'Linux'
				{
				$Global:vmxtoolkit_type = "LINUX"
				#$OS_Version = (sw_vers)
				#$OS_Version = $OS_Version -join " "
				$VMX_BasePath = '/var/lib/vmware/Shared VMs'
				$VMware_Path = "/usr/bin"
				$Global:vmwarepath = $VMware_Path
				$VMware_BIN_Path = $VMware_Path  
				$Global:VMware_vdiskmanager = Join-Path $VMware_BIN_Path 'vmware-vdiskmanager'
				$GLobal:VMware_packer = Join-Path $VMware_BIN_Path '7za'
				$Global:vmrun = Join-Path $VMware_BIN_Path "vmrun"
				$Global:VMware_OVFTool = Join-Path $VMware_Path 'ovftool'
				$Vmware_Base_Version = (vmware -v)
				$Vmware_Base_Version = $Vmware_Base_Version -replace "VMware Workstation "
				[version]$Global:vmwareversion = ($Vmware_Base_Version.Split(' '))[0]
				}
				default
				{
				Write-host "Sorry, rome was not build in one day"
				exit
				}
			}
		}
	}
if (!$VMX_Path)
	{
	try
		{
		$Global:vmxdir = Join-Path $HOME $VMX_Basedir
		}
	catch
		{
		Write-Warning "could not evaluate default Virtula machines home, using $PSScriptRoot"
		$Global:vmxdir = $PSScriptRoot
		}
	}
else
	{
	$Global:vmxdir = $VMX_Path
	}

#### some vmx api error handlers :-) false positives from experience
>>>>>>> develop
$Global:VMrunErrorCondition = @(
  "Waiting for Command execution Available",
  "Error",
  "Unable to connect to host.",
  "Error: Unable to connect to host.",
  "Error: The operation is not supported for the specified parameters",
  "Unable to connect to host. Error: The operation is not supported for the specified parameters",
  "Error: The operation is not supported for the specified parameters",
  "Error: vmrun was unable to start. Please make sure that vmrun is installed correctly and that you have enough resources available on your system.",
  "Error: The specified guest user must be logged in interactively to perform this operation",
  "Error: A file was not found",
  "Error: VMware Tools are not running in the guest",
  "Error: The VMware Tools are not running in the virtual machine" )
<<<<<<< HEAD
$Global:vmwareversion = New-Object System.Version($vmwarefileinfo.VersionInfo.ProductMajorPart,$vmwarefileinfo.VersionInfo.ProductMinorPart,$vmwarefileinfo.VersionInfo.ProductBuildPart,$vmwarefileinfo.VersionInfo.ProductVersion.Split("-")[1])
# $Global:vmwareMajor = $vmwarefileinfo.VersionInfo.ProductMajorPart
# $Global:vmwareMinor = $vmwarefileinfo.VersionInfo.ProductMinorPart
# $Global:vmwareBuild = $vmwarefileinfo.VersionInfo.ProductBuildPart
# $Global:vmwareversion = $vmwarefileinfo.VersionInfo.ProductVersion
=======
if (Test-Path $GLobal:VMware_packer)
	{
	Write-Host -ForegroundColor Gray " ==>found $GLobal:VMware_packer"
	}
else
	{
	Write-Warning "Please install 7za/p7zip, otherwise labbtools can not expand OS Masters"
	}
if ($OS_Version)
	{
	write-Host -ForegroundColor Gray " ==>$OS_Version"
	}
Write-Host -ForegroundColor Gray " ==>running vmxtoolkit for $Global:vmxtoolkit_type"
Write-Host -ForegroundColor Gray " ==>vmrun used from $Global:vmrun"
Write-Host -ForegroundColor Gray " ==>vmwarepath is $Global:vmwarepath"
Write-Host -ForegroundColor Gray " ==>virtual machine directory from module load is $Global:vmxdir"
Write-Host -ForegroundColor Gray " ==>default vmxdir is $Global:vmxdir"
Write-Host -ForegroundColor Gray " ==>running VMware Version Mode $Global:vmwareversion"
Write-Host -ForegroundColor Gray " ==>OVFtool $Global:VMware_OVFTool"
Write-Host -ForegroundColor Gray " ==>Packertool $GLobal:VMware_packer"
Write-Host -ForegroundColor Gray " ==>vdisk manager is $Global:vmware_vdiskmanager"
>>>>>>> develop
