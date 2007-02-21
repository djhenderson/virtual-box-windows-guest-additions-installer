!define NAME "VirtualBox OSE Windows Guest Additions"
!define VERSION 1.3.6

Name "${NAME}"
InstallDir "$PROGRAMFILES\VirtualBox OSE Guest Additions"
OutFile VirtualBox_OSE_GuestAdditions_${VERSION}.exe

Page instfiles
UninstPage uninstConfirm
UninstPage instfiles

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

    Delete $INSTDIR\uninstall.exe
    DeleteRegKey HKLM \
        "Software\Microsoft\Windows\CurrentVersion\Uninstall\VBoxOSEGuest"

    RMDir $INSTDIR
SectionEnd
