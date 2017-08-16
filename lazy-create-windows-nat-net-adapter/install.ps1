#ps1
$switchName = "VMInternalSwitch"
$natNetwork = "NATNetwork"
$subnet = "192.168.137.0/24"

# Create VM Switch
New-VMSwitch -SwitchName $switchName -SwitchType Internal

# Get VMswitch associated net adapter index
$index = (Get-NetAdapter -Name "*($switchName)").IfIndex

# Create the gateway
New-NetIPAddress -IPAddress (($subnet -split "/")[0]).replace(".0",".1") -PrefixLength (($subnet -split "/")[1]) -InterfaceIndex $index

# Get the nat network and remove if it exists -- needs confirmation
Get-NetNat | Remove-NetNat -Confirm:$true

# Create and configure the NAT Network
New-NetNat -Name $natNetwork -InternalIPInterfaceAddressPrefix $subnet
