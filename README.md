#  Azure Virtual Desktop as a gaming console
This repository contains source codes, samples and videos presented in the session "Azure Virtual Desktop as a gaming console"

<a href="https://youtu.be/NmNbgH2rLfw">Running Doom inside Azure Virtual Desktop</a>

<a href="https://youtu.be/6cMD8_U4Keg">Running Fortnite inside Azure Virtual Desktop</a>

<a href="https://youtu.be/9-w7iVDQ7n4">Running Flight Simulator inside Azure Virtual Desktop</a>

<a href="https://youtu.be/G-jGSm_DP3A">Running Larry inside Azure Virtual Desktop</a>


<img align="center" src="https://github.com/fberson/Azure-Virtual-Desktop-as-a-gaming-console/blob/main/Visualizer.png">

File | Contents
----------------------------------------- | -------------
Add-AVDGPUHostToHostpool.ps1 | Adds an WVD Session Host to an existing WVD Hostpool using a provided registrationKey and configures GPU and direct path settings
main.bicep | The main bicep file that deploys the full environment leveraging the various Bicep modules
module-avd-backplane.bicep | Bicep module that deploys an Azure Virtual Desktop backplane infrastructure
module-avd-diag-appgroup.bicep | Bicep module that deploys that configures diagnostic settings for av AVD App Group
module-avd-diag-hostpool.bicep | Bicep module that deploys that configures diagnostic settings for av AVD Host Pool
module-avd-diag-workspace.bicep | Bicep module that deploys that configures diagnostic settings for av AVD Workspace
module-avd-monitor.bicep | Bicep module that deploys various diagnostic modules
module-avd-network.bicep | Bicep module that deploys a vnet and subnet
module-avd-sessionhost.bicep | Bicep module that deploys Session Hosts, joins them to a domain and configures AVD agents and GPU settings
module-avd-vnet-peering.bicep | Bicep module that configures peering towards an ADDS vnet
module-avdlog-analytics.bicep | Bicep module that deploys Log Analtyics for AVD Insight

