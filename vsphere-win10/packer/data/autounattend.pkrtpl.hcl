<unattend xmlns="urn:schemas-microsoft-com:unattend">
    <servicing/>
    <settings pass="windowsPE">  
        <component name="Microsoft-Windows-PnpCustomizationsWinPE" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <DriverPaths>
                <PathAndCredentials wcm:action="add" wcm:keyValue="A">
                    <Path>A:\</Path>
                </PathAndCredentials>
            </DriverPaths>
        </component>  
        <component xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" name="Microsoft-Windows-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">
            <DiskConfiguration>
                <Disk wcm:action="add">
                    <CreatePartitions>
                        <CreatePartition wcm:action="add">
                            <Order>1</Order>
                            <Size>1000</Size>
                            <Type>Primary</Type>
                        </CreatePartition>
                        <CreatePartition wcm:action="add">
                            <Order>2</Order>
                            <Size>100</Size>
                            <Type>EFI</Type>
                        </CreatePartition>
                        <CreatePartition wcm:action="add">
                            <Order>3</Order>
                            <Size>128</Size>
                            <Type>MSR</Type>
                        </CreatePartition>
                        <CreatePartition wcm:action="add">
                            <Order>4</Order>
                            <Extend>true</Extend>
                            <Type>Primary</Type>
                        </CreatePartition>
				    </CreatePartitions>
                    <ModifyPartitions>
                        <ModifyPartition wcm:action="add">
                            <Order>1</Order>
                            <PartitionID>1</PartitionID>
                            <Format>NTFS</Format>
                            <Label>WindowsRecovery</Label>
                            <TypeID>DE94BBA4-06D1-4D40-A16A-BFD50179D6AC</TypeID>
                        </ModifyPartition>
                        <ModifyPartition wcm:action="add">
                            <Order>2</Order>
                            <PartitionID>2</PartitionID>
                            <Label>System</Label>
                            <Format>FAT32</Format>
                        </ModifyPartition>
                        <ModifyPartition wcm:action="add">
                            <Order>3</Order>
                            <PartitionID>3</PartitionID>
                        </ModifyPartition>
                        <ModifyPartition wcm:action="add">
                            <Order>4</Order>
                            <PartitionID>4</PartitionID>
                            <Letter>C</Letter>
                            <Label>Windows</Label>
                            <Format>NTFS</Format>
                        </ModifyPartition>
				    </ModifyPartitions>
                    <DiskID>0</DiskID>
                    <WillWipeDisk>true</WillWipeDisk>
                </Disk>
            </DiskConfiguration>
            <ImageInstall>
                <OSImage>
                    <InstallFrom>
                        <MetaData wcm:action="add">
                            <Key>/IMAGE/NAME</Key>
                            <Value>Windows 10 Pro</Value>
                        </MetaData>
                    </InstallFrom>
                    <InstallTo>
                        <DiskID>0</DiskID>
                        <PartitionID>4</PartitionID>
                    </InstallTo>
                    <WillShowUI>OnError</WillShowUI>
                    <InstallToAvailablePartition>false</InstallToAvailablePartition>
                </OSImage>
            </ImageInstall>
            <UserData>
                <AcceptEula>true</AcceptEula>
                <FullName>Edward Ingram</FullName>
                <Organization>HomeLab</Organization>
                <ProductKey>
                    <Key>VK7JG-NPHTM-C97JM-9MPGT-3V66T</Key>
                    <!-- This key is a generic public Windows 10 Pro key for autounattend and so on. -->
                </ProductKey>
            </UserData>
        </component>
        <component xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" name="Microsoft-Windows-International-Core-WinPE" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">
           <SetupUILanguage>
                <UILanguage>en-US</UILanguage>
            </SetupUILanguage>
            <InputLocale>en-US</InputLocale>
            <SystemLocale>en-US</SystemLocale>
            <UILanguage>en-US</UILanguage>
            <UserLocale>en-US</UserLocale>
        </component>
    </settings>
    <settings pass="oobeSystem">
        <component name="Microsoft-Windows-International-Core" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <InputLocale>en-GB</InputLocale>
            <UILanguage>en-GB</UILanguage>
            <UILanguageFallback>en-US</UILanguageFallback>
            <UserLocale>en-GB</UserLocale>
            <SystemLocale>en-GB</SystemLocale>
        </component>
        <component xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">
            <UserAccounts>
                <LocalAccounts>
                    <LocalAccount wcm:action="add">
                        <Password>
                            <Value>temppassword</Value>
                            <PlainText>true</PlainText>
                        </Password>
                        <Description>Local administrator account.</Description>
                        <DisplayName>Administrator</DisplayName>
                        <Group>Administrators</Group>
                        <Name>administrator</Name>
                    </LocalAccount>
                </LocalAccounts>
            </UserAccounts>
            <AutoLogon>
                <Password>
                    <Value>temppassword</Value>
                    <PlainText>true</PlainText>
                </Password>
                <Enabled>true</Enabled>
                <Username>administrator</Username>
            </AutoLogon>
            <OOBE>
                <HideEULAPage>true</HideEULAPage>
                <HideOEMRegistrationScreen>true</HideOEMRegistrationScreen>
                <HideOnlineAccountScreens>true</HideOnlineAccountScreens>
                <HideWirelessSetupInOOBE>true</HideWirelessSetupInOOBE>
                <ProtectYourPC>3</ProtectYourPC>
            </OOBE>
            <FirstLogonCommands>
                <SynchronousCommand wcm:action="add">
                    <Order>1</Order>
                    <CommandLine>cmd.exe /c PowerShell -Command "Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope LocalMachine"</CommandLine>
                    <Description>Change the default PowerShell Execution Policy from Restricted to RemoteSigned</Description>
                </SynchronousCommand>
                <SynchronousCommand wcm:action="add">
                    <Order>2</Order>
                    <CommandLine>C:\Windows\SysWOW64\cmd /c PowerShell -Command "Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope LocalMachine"</CommandLine>
                    <Description>Change the default PowerShell (32-bit) Execution Policy from Restricted to RemoteSigned</Description>
                </SynchronousCommand>
                <SynchronousCommand wcm:action="add">
                    <CommandLine>PowerShell reg add "HKLM\System\CurrentControlSet\Control\Network\NewNetworkWindowOff"</CommandLine>
                    <Description>Disable network window prompt when Windows first connects to a network.</Description>
                    <Order>3</Order>
                </SynchronousCommand>
                <SynchronousCommand wcm:action="add">
                    <CommandLine>%SystemRoot%\System32\reg.exe ADD HKLM\SYSTEM\CurrentControlSet\Control\Power\ /v HibernateFileSizePercent /t REG_DWORD /d 0 /f</CommandLine>
                    <Order>8</Order>
                    <Description>Zero Hibernation File</Description>
                </SynchronousCommand>
                <SynchronousCommand wcm:action="add">
                    <CommandLine>%SystemRoot%\System32\reg.exe ADD HKLM\SYSTEM\CurrentControlSet\Control\Power\ /v HibernateEnabled /t REG_DWORD /d 0 /f</CommandLine>
                    <Order>9</Order>
                    <Description>Disable Hibernation Mode</Description>
                </SynchronousCommand>
               <SynchronousCommand wcm:action="add">
                    <CommandLine>Powershell -ExecutionPolicy Bypass -File a:\scripts\install_vmware_tools.ps1</CommandLine>
                    <Description>PS1 Script to install VMware Tools for connectivity due to VMNet adapters, performance gains etc.</Description>
                    <Order>4</Order>
                </SynchronousCommand>
                <SynchronousCommand wcm:action="add">
                    <CommandLine>Powershell -ExecutionPolicy Bypass -File a:\scripts\configure_winrm_win10.ps1</CommandLine>
                    <Description>Configure WinRM connectivity. Required for Packer connectivity.</Description>
                    <Order>5</Order>
                </SynchronousCommand>
            </FirstLogonCommands>
        </component>
    </settings>
    <settings pass="specialize">
        <component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">
            <TimeZone>Pacific Standard Time</TimeZone>
            <RegisteredOrganization>HomeLab</RegisteredOrganization>
            <RegisteredOwner>Edward Ingram</RegisteredOwner>
            <ComputerName>*</ComputerName>
        </component>
        <component xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" name="Microsoft-Windows-Security-SPP-UX" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">
            <SkipAutoActivation>true</SkipAutoActivation>
        </component>
    </settings>
    <cpi:offlineImage cpi:source="wim:c:/users/dmartins/desktop/windows10/sources/install.wim#Windows 10 Pro" xmlns:cpi="urn:schemas-microsoft-com:cpi" />
</unattend>