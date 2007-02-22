!define NAME "VirtualBox OSE Windows Guest Additions"
!define VERSION 1.3.6

Name "${NAME}"
InstallDir "$PROGRAMFILES\VirtualBox OSE Guest Additions"
OutFile VirtualBox_OSE_GuestAdditions_${VERSION}.exe

; TODO: add version information
; TODO: switch to modern ui

; TODO: add page about distribution under the GPL
Page instfiles
UninstPage uninstConfirm
UninstPage instfiles

!include "driver-helpers.nsh"

Section "Install Files"
    SetOutPath $INSTDIR
    
    ; guest driver
    File additions\VBoxGuest.inf
    File additions\VBoxGuest.sys
    File additions\VBoxService.exe
    File additions\VBoxControl.exe

    ; video driver
    File additions\VBoxVideo.inf
    File additions\VBoxVideo.sys
    File additions\VBoxDisp.dll

    ; mouse filter/driver
    File additions\VBoxMouse.inf
    File additions\VBoxMouse.sys

    ; GINA replacement
    File additions\VBoxGINA.dll

    WriteUninstaller $INSTDIR\uninstall.exe
    WriteRegStr HKLM \
        "Software\Microsoft\Windows\CurrentVersion\Uninstall\VBoxOSEGuest" \
        "DisplayName" "${NAME}"
    WriteRegStr HKLM \
        "Software\Microsoft\Windows\CurrentVersion\Uninstall\VBoxOSEGuest" \
        "UninstallString" "$INSTDIR\uninstall.exe"
    WriteRegStr HKLM \
        "Software\Microsoft\Windows\CurrentVersion\Uninstall\VBoxOSEGuest" \
        "InstallLocation" $INSTDIR
SectionEnd

Section "Install Drivers"
    ; guest driver
    Push "PCI\VEN_80ee&DEV_cafe"
    Push $INSTDIR\VBoxGuest.inf
    DetailPrint "Installing VirtualBox Guest Driver"
    Call InstallPlugAndPlayDriver

    ; video driver
    Push "PCI\VEN_80EE&DEV_BEEF"
    Push $INSTDIR\VBoxVideo.inf
    DetailPrint "Installing VirtualBox Video Driver"
    Call InstallPlugAndPlayDriver

    ; mouse/filter driver
    SetOutPath $INSTDIR
    Push VBoxMouse.inf
    DetailPrint "Installing VirtualBox Mouse Driver"
    Call InstallDriver 

    ; FIXME: find out why the reboot prompt does not appear
    ; really need to reboot to get everything working
    SetRebootFlag true
SectionEnd

Section "un.Install Drivers"
    ; TODO: safely remove the drivers
    DetailPrint "should uninstall drivers here"
SectionEnd

Section "un.Install Files"
    ; guest driver
    Delete $INSTDIR\VBoxGuest.inf
    Delete $INSTDIR\VBoxGuest.sys
    Delete $INSTDIR\VBoxService.exe
    Delete $INSTDIR\VBoxControl.exe

    ; video driver
    Delete $INSTDIR\VBoxVideo.inf
    Delete $INSTDIR\VBoxVideo.sys
    Delete $INSTDIR\VBoxDisp.dll

    ; mouse filter/driver
    Delete $INSTDIR\VBoxMouse.inf
    Delete $INSTDIR\VBoxMouse.sys

    ; TODO: remove the registry key if the VBoxGINA is in use
    ; GINA replacement
    Delete $INSTDIR\VBoxGINA.dll
SectionEnd

Section "Uninstall"
    Delete $INSTDIR\uninstall.exe
    DeleteRegKey HKLM \
        "Software\Microsoft\Windows\CurrentVersion\Uninstall\VBoxOSEGuest"
    RMDir $INSTDIR
SectionEnd
