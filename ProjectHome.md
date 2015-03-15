This project provides a packaged version of the Windows Guest Addition tools for VirtualBox OSE.  This is provided so that users will not have to create a Windows build environment just to build the guest additions.

See also [the wiki](http://code.google.com/p/virtual-box-windows-guest-additions-installer/wiki/MainPage) for more information.

### 4.0.0 ###
With the 4.0.0 release of VBox, and the beta versions before, Oracle migrated the windows development tools from Visual Studio 2005 and the 2003R2 DDK to VS10 and the Vista/Win7 DDK. Unfortunately, the migration is not yet complete, nor has information about a working build setup been released (the build instructions on virtualbox.org date back to 2.x.y times, still).

Therefore, I have not yet been able to compile VBox on Windows. A member of the VBox Team promised this information is to be released among the 4.0.x versions, once the dev setup has been stabilised at Oracle. Until then, I cannot release a set of VBox GA for the 4.0.x versions.

If someone manages to compile the stuff, please tell me!

### Version dependencies ###
Note:<br />
There is a problem with VBox 3.0.6 and save/restore on multi-core XP (complete hang after resume, sometimes PAGE\_FAULT\_IN\_NONPAGED\_AREA). In this case, use the following combinations:
  * VBox 3.0.6: OSE GA 3.0.4-2
  * VBox 3.0.8 and above: OSE GA 3.0.12
  * VBox 3.1.0 and above: OSE GA 3.1.8
  * VBox 3.2.# and above: if possible, use the same version of the GA as the virtual machine software.

Please note that there may be a time sync issue (on suspend/resume vm) with GA >= 3.2.0 and VBox 3.1.8.

### Codesigning and Windows Vista, 7 ###
I just started to sign the driver, starting with 3.2.0-1. There is an additional "-signed" in the file name. This should make it possible to "just install" the drivers on win7 and vista. I'm using a self signed certificat, thus, you need to click on "install anyway", still.

You also need to get the sbrandt-vbox-ca.cer, and install it into the "Trusted Root Certification Authorities". Maybe it will work better - please give feedback ;)

The .sys and stuff are still given as "not signed", because the files themselves are not signed (which is unecessary in this context), only the installation is signed.