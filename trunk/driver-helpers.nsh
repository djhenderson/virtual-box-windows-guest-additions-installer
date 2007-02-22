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
