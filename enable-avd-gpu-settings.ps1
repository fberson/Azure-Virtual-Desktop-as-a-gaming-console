New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services' -Name 'bEnumerateHWBeforeSW' -Value 1  -PropertyType 'DWORD'
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services' -Name 'AVCHardwareEncodePreferred' -Value 1  -PropertyType 'DWORD'


