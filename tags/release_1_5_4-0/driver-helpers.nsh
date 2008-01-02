; driver-helpers.nsh
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

!define update_driver_for_pnp_devices \
    "newdev::UpdateDriverForPlugAndPlayDevices(i, t, t, i, *i) i"

; InstallPlugAndPlayDriver
;
; Expects that the device has already been inserted
;
; Parameters (top of stack on last)
; - HardwareId (eg. PCI\VEN_0f00&DEV_0bad)
; - FullInfPath (eg. c:\foo\bar\foobar.inf
; 
; Parameters on stack are destroyed.
; $R{0,1} are destroyed.
;
; Status is returned on the top of the stack.
; - 1 for success, 0 for failure
;
; If a reboot is required, the global reboot flag will be set.
; 
Function InstallPlugAndPlayDriver
    ; grab arguments
    Pop $R0 ; FullInfPath
    Pop $R1 ; HardwareId

    ; save internally used variables
    Push $0
    Push $1

    System::Call "${update_driver_for_pnp_devices} ($HWNDPARENT, R1, R0, 0, .r1) .r0"

    ; check to see if a reboot is needed
    StrCmp $1 0 0 +2
    SetRebootFlag true

    Pop $1
    Exch $0 ; leaves the result on the top of the stack
FunctionEnd

; InstallDriver
;
; Parameters (top of stack on last)
; - InfName (eg. foobar.inf)
;
; Assumes that $OUTDIR is set to the directory containing InfName.
; 
; Parameters on stack are destroyed.
;
; The called API function returns no status.
; There is also no way of knowing if a reboot is required.
; 
; The caller must know their driver and hope for the best.
; 
Function InstallDriver
    ; grab arguments
    Exch $R0 ; InfName
    
    ; save locally used arguments
    Push $0
   
    StrCpy $0 '"$SYSDIR\rundll32.exe" setupapi,InstallHinfSection DefaultInstall 128 .\$R0'
    nsExec::ExecToLog $0

    ; restore locally used arguments
    Pop $0
    Pop $R0
FunctionEnd
