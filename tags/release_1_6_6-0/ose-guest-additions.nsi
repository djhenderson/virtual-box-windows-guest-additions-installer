; ose-guest-additions.nsi
;
; Copyright 2007-2008 Byron Clark
; 
; This file is part of the VirtualBox OSE Guest Additions Installer.
;
; The VirtualBox OSE Guest Additions Installer is free software; you can
; redistribute it and/or modify it under the terms of the GNU General Public
; License as published by the Free Software Foundation; either version 2 of 
; the License, or (at your option) any later version.
;
; The VirtualBox OSE Guest Additions Installer is distributed in the hope
; that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
; warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with the VirtualBox OSE Guest Additions Installer; if not, write to 
; the Free Software Foundation, Inc., 51 Franklin St, Fifth Floor, 
; Boston, MA  02110-1301  USA
; 

SetCompressor /SOLID lzma

!addplugindir setup-processes\bin
!include "MUI.nsh"

!define NAME "VirtualBox OSE Guest Additions"
!define VERSION 1.6.6
!define INSTALLER_BUILD 0

Name "${NAME}"
InstallDir "$PROGRAMFILES\${NAME}"
OutFile VirtualBox_OSE_GuestAdditions-${VERSION}-${INSTALLER_BUILD}.exe
RequestExecutionLevel admin

; TODO: add version information

Function OnGuiStart
    ; TODO: check windows version
    ; need to find license information on the get windows version
    ; script available at http://nsis.sourceforge.net/Get_Windows_version

    UserInfo::GetAccountType
    Pop $0
    StrCmp $0 "Admin" +3 0
        MessageBox MB_OK "The VirtualBox OSE Guest Additions must be installed by a member of the Administrators group."
        Quit
FunctionEnd

Function KillRunningProcess
    ; grab arguments
    Pop $R1 ; process name
    
    Processes::FindProcess "$R1"
    StrCmp $R0 "1" krp_do_kill krp_success

    krp_do_kill:
    Processes::KillProcess "$R1"
    StrCmp $R0 "1" krp_success krp_kill_failed

    krp_kill_failed:
    Processes::FindProcess "$R1"
    StrCmp $R0 "1" krp_wont_die krp_success

    krp_wont_die:
    push 1
    Goto krp_return

    krp_success:
    ; Make sure the process has exited
    Processes::FindProcess "$R1"
    StrCmp $R0 "1" krp_success
    push 0

    krp_return:
FunctionEnd

!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\orange-install.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\orange-uninstall.ico"
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP "${NSISDIR}\Contrib\Graphics\Header\orange.bmp"
!define MUI_HEADERIMAGE_UNBITMAP "${NSISDIR}\Contrib\Graphics\Header\orange-uninstall.bmp"
!define MUI_WELCOMEFINISHPAGE_BITMAP "${NSISDIR}\Contrib\Graphics\Wizard\orange.bmp"
!define MUI_UNWELCOMEFINISHPAGE_BITMAP "${NSISDIR}\Contrib\Graphics\Wizard\orange-uninstall.bmp"

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

!define MUI_CUSTOMFUNCTION_GUIINIT OnGuiStart

!insertmacro MUI_LANGUAGE "English"

!include "driver-helpers.nsh"

Section "Install Files"
    ; Make sure the tray application is stopped
    DetailPrint "Stopping VBoxService.exe"
    Push "VBoxService"
    Call KillRunningProcess
    Pop $R0
    StrCmp $R0 0 service_kill_success service_kill_failure
    service_kill_failure:
    Abort "Unable to stop VBoxService.exe"
    service_kill_success:

    DetailPrint "Stopping VBoxTray.exe"
    Push "VBoxTray"
    Call KillRunningProcess
    Pop $R0
    StrCmp $R0 0 tray_kill_success tray_kill_failure
    tray_kill_failure:
    Abort "Unable to stop VBoxTray.exe"
    tray_kill_success:

    SetOutPath $INSTDIR
    
    ; guest driver
    File additions\VBoxGuest.inf
    File additions\VBoxGuest.sys
    File additions\VBoxTray.exe
    File additions\VBoxControl.exe

    ; video driver
    File additions\VBoxVideo.inf
    File additions\VBoxVideo.sys
    File additions\VBoxDisp.dll

    ; mouse filter/driver
    File additions\VBoxMouse.inf
    File additions\VBoxMouse.sys

    ; global hook
    SetOutPath $SYSDIR
    File additions\VBoxHook.dll
    SetOutPath $INSTDIR
    File additions\VBoxHook.dll

    ; GINA replacement
    File additions\VBoxGINA.dll

    ; OpenGL driver
    File additions\VBoxOGL.dll

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
    WriteRegStr HKLM \
        "Software\Microsoft\Windows\CurrentVersion\Uninstall\VBoxOSEGuest" \
        "DisplayIcon" "$INSTDIR\VBoxTray.exe,0"
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
    Delete $INSTDIR\VBoxTray.exe
    Delete $INSTDIR\VBoxControl.exe

    ; video driver
    Delete $INSTDIR\VBoxVideo.inf
    Delete $INSTDIR\VBoxVideo.sys
    Delete $INSTDIR\VBoxDisp.dll

    ; mouse filter/driver
    Delete $INSTDIR\VBoxMouse.inf
    Delete $INSTDIR\VBoxMouse.sys

    ; global hook
    Delete $SYSDIR\VBoxHook.dll
    Delete $INSTDIR\VBoxHook.dll


    ; TODO: remove the registry key if the VBoxGINA is in use
    ; GINA replacement
    Delete $INSTDIR\VBoxGINA.dll

    ; OpenGL driver
    Delete $INSTDIR\VBoxOGL.dll    
SectionEnd

Section "Uninstall"
    Delete $INSTDIR\uninstall.exe
    DeleteRegKey HKLM \
        "Software\Microsoft\Windows\CurrentVersion\Uninstall\VBoxOSEGuest"
    RMDir $INSTDIR
SectionEnd