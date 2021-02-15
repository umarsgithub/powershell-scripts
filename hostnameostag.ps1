$thisprof = "mydevprofile" #change this value as relevant

$wmiOS = Get-WmiObject -Class Win32_OperatingSystem;
$OS = $wmiOS.caption

try {
    $ec2hostname = ([System.Net.Dns]::GetHostByName($env:computerName)).HostName
    }
catch {    $ec2hostname = (Get-WmiObject win32_computersystem).DNSHostName+"."+(Get-WmiObject win32_computersystem).Domain
  }
  
Set-AWSCredential -AccessKey "Access Key ID goes here" -SecretKey "SECRET ACCESS KEY GOES HERE" -StoreAs $thisprof # remember these change depending on the AWS account
Set-AWSCredential -ProfileName $thisprof
Set-DefaultAWSRegion -Region eu-west-2 #change to eu-west-1 if instances are in ireland

$HostnameTag = New-Object Amazon.EC2.Model.Tag
$HostnameTag.Key = "Hostname"
$HostnameTag.Value = $ec2hostname

New-EC2Tag -Resource (Get-EC2InstanceMetadata -Category InstanceId) -Tag $HostNameTag

$OSTag = New-Object Amazon.EC2.Model.Tag
$OSTag.Key = "OS"
$OSTag.Value = $OS

New-EC2Tag -Resource (Get-EC2InstanceMetadata -Category InstanceId) -Tag $OSTag


Remove-AWSCredentialProfile -ProfileName $thisprof

#Requires windows management framework 5.1, awspowershell & SSM agent to be installed on server & a relevant SSM IAM role
#If you get a typeload exception http://thinkingrounds.blogspot.com/2017/07/awspowershell-module-unable-to-load.html
