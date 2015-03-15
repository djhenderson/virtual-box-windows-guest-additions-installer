# VirtualBox Guest Additions for Windows OSE #

Binary/Compiled version of the VirtualBox Guest Additions for Windows, Open Source Edition (OSE) version. Including installer.

## Visual C++ 2005 runtime dlls ##
It might be necessary to install the correct or most current version of the "_Microsoft Visual C++ 2005 Service Pack 1 Redistributable Package_" to run the additions. A "side-by-side installation error" is thrown, otherwise.

The current packages are:
  * Microsoft Visual C++ 2005 Service Pack 1 Redistributable Package ATL Security Update <br /> July 28th, 2009<br />http://www.microsoft.com/downloads/details.aspx?familyid=766A6AF7-EC73-40FF-B072-9112BAB119C2
  * Microsoft Visual C++ 2005 SP1 Redistributable Package (x86)<br /> Aug 27th, 2007<br />http://www.microsoft.com/downloads/details.aspx?familyid=200B2FD9-AE1A-4A14-984D-389C36F85647

Though I rather believe no C nor C++ dlls are needed.

## 3.3.0-# ##
Sorry for the version numbering mixup. The 3.3.0 downloads are 3.0.0, of course.
Corrected since 3.0.0-3.

# Details #

The current version of the installer, VirtualBox\_OSE\_GuestAdditions-2.2.0-1.exe, is based on the 2.2.0 version of VirtualBox OSE. It has been compiled with MS Visual Studio 2005 (aka Visual C++ 8.0).

It should be possible to install the additions on any VBox guest system running Windows 2000, XP, or later. Provided are the following:

  * Graphics driver
  * Mouse driver
  * OpenGL driver
  * VirtualBox.exe and .sys Guest system drivers

The installation has not been yet thoroughly tested, only on Windows XP.
Graphics performance, especially OpenGL, appears to be less than the PUEL version provided by SUN.

Some issues are still open:
  * Clean uninstall of the drivers
  * Checking for VBox guest
  * Disallow installing when SUN xVM Guest Additions are (still) installed.

Please uninstall any Guest Additions provided by SUN or InnoTek (PUEL/commercial).


## VirtualBox 3.0.0 and Direct3D ##

3.0.0 has a problem, so does 3.0.2 - check [Issue 18](http://code.google.com/p/virtual-box-windows-guest-additions-installer/issues/detail?id=18) -- VBoxService does not start.
Therefore, the current installs contain the VBoxService.exe from 2.2.4 which still does work. Thus, 3.0.0-2 is "featured", again - and will be replaced by 3.0.2, soon.

An installer for the 3.0.0 additions has just been created.
When installed in safe mode, the Direct3D dlls (d3d8.dll and d3d9.dll) in the system32 directory are replaced. VirtualBox then routes the D3D calls to the wine3d implementation which "converts" them to OpenGL, which is already supported in the guest->host setup.

### Alternative to Safe Mode Installation ###
_Thanks to Jérôme Poulin_

I don't know if it has been talked before on the mailing list, but there's no need to have to force installation in safe mode.

You can simply rename the following values while installing:
`SourcePath`
`ServicePackSourcePath`
in
`HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Setup\`

and warn the user that Windows could pop-up a warning during installation, to just cancel and accept and of course make sure there's no Windows CD in the drive, but in the case of additions installation, it should not happen.

You should also make sure the files do not appear in `%windir%\system32\dllcache` and finally rename the files to replace and select them for deletion on reboot. Put the new files and undo the values renaming, reboot, all done!


## Windows 7 ##
For windows 7, you need to install the graphics driver manually.
Device Manager, Update graphics driver, Search on computer, "C:\Program Files\VirtualBox OSE Guest Additions", VirtualBox graphics driver.

In seamless mode, the "gadgets" are shown on the host desktop, and can be moved around - alpha blending is missing, though.

According to the discussion group, some people also had success with using the "compatibility assistant" and installing in Vista mode. I'm not even asked about the unsigned drivers. Maybe driver signing needs to be disabled? Or I should sign the drivers ...

I'm getting the impression that it is possible to install the drivers, but very hard to replace them ... "just" copying the **.exe and**.dll may be the best solution here?
Updating the graphics driver:
"Update graphics driver", "Search on computer", "Select from (a?) list of ...", "Disk", "C:\Program Files\VirtualBox OSE Guest Additions", VirtualBox graphics driver (current version).

Updating some of the OpenGL dlls seem to work in safe mode, otherwise they are locked (Vista compatibility mode). VBoxService and VBoxTray.exe are not replaced in compat mode, but you can just kill the two processes and replace them manually via explorer (at least two dialog boxes, file replacing and UAC).


## Compilation ##
According to Frank Mehnert (Sun/Oracle), it is possible to compile the additions only with
kmk VBOX\_ONLY\_ADDITIONS=1
Adding BUILD\_TARGET=win even allows to compile the windows additions on a linux system, with MSC (Visual Studio) (+ Wine on Linux) installed. Sounds difficult.

Unfortunately, to compile the additions only on windows, you still need the complete VBox "kit" for the configure.vbs to finish correctly. Maybe, this can be helped by creating a reduced configure.vbs that only contains the stuff for the additions.

You need at least:
  * Platform SDK
  * DirectX SDK
  * Driver DK
You do not need:
  * Qt4
  * MinGW (incl. gcc and libsdl)

# License #
GNU General Public License (GPL) v2