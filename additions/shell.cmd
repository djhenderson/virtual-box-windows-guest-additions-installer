@echo off
PATH=%PATH%;C:\Programme\Microsoft Winqual Submission Tool
rem %comspec% /k 
call "C:\Programme\Microsoft Visual Studio 8\Common7\Tools\vsvars32.bat"

echo inf2cat /driver:. /os:2000,XP_X86,Vista_X86,7_X86
echo signtool sign /v /s PrivateCertStore /n "Sebastian C. Brandt" /sha1 "4902ee3772f13145740b32c135e0ea872bcb6e38" /t http://timestamp.verisign.com/scripts/timestamp.dll vboxmouse.cat vboxvideo.cat vboxguest.cat
echo signtool verify /pa /v /c vboxguest.cat VBoxGuest.inf
echo signtool verify /pa /v /c vboxmouse.cat VBoxMouse.inf
echo signtool verify /pa /v /c vboxvideo.cat VBoxVideo.inf

cmd

C:\home\VirtualBox\virtual-box-windows-guest-additions-installer\additions>

"Eigene Zertifikate" statt "PrivateCertStore"? ist dann aber eigene zertifikate!=eigene zertifikate
wie neues Zertifikat mit gleichem Schlüssel? --> -sk

http://msdn.microsoft.com/en-us/library/bfsktky3.aspx
# -d "Sebastian C. Brandt (CA)"
-r selfsigned, sonst Issuer angeben
makecert -r -pe -cy end -sk SCBrandtKey -# 2 -$ individual -a sha1 -ss PrivateCertStore -n "CN=Sebastian C. Brandt,E=csbac74@googlemail.com" sbrandt-vbox.cer


makecert -r -pe -cy authority -h 1 -sk SCBrandtCAKey -# 3 -$ individual -a sha1 -ss PrivateCertStore -n "CN=Sebastian C. Brandt (CA),E=csbac74@googlemail.com" sbrandt-vbox-ca.cer

makecert -pe -cy end -sk SCBrandtKey -# 5 -$ individual -a sha1 -in "Sebastian C. Brandt (CA)" -is PrivateCertStore -ss PrivateCertStore -n "CN=Sebastian C. Brandt,E=csbac74@googlemail.com" sbrandt-vbox.cer

--> gotcha!


rem makecert -r -pe -sk SCBrandtKey -ss PrivateCertStore -n "CN=Sebastian C. Brandt,E=csbac74@googlemail.com" sbrandt-vbox.cer
beide installieren

CatalogFile=..cat in den Infs, [Version]
inf2cat /driver:. /os:2000,XP_X86,Vista_X86,7_X86 /v
der schaut dann auch nach den .svn-dateien .. mh
22.9.6: DriverVer missing or in incorrect format in \vboxmouse.inf


Signability test complete.

Errors:
None

Warnings:
22.9.8: Possible Windows XP/Windows Server 2003 file redistribution violation (\d3d8.dll --> d3d8.dll). File not copiedby installation inf so this is a warning only.
22.9.8: Possible Windows Vista/Windows Server 2008 file redistribution violation (\d3d8.dll --> d3d8.dll). File not coped by installation inf so this is a warning only.

Catalog generation complete.
C:\home\VirtualBox\virtual-box-windows-guest-additions-installer\additions\vboxguest.cat
C:\home\VirtualBox\virtual-box-windows-guest-additions-installer\additions\vboxvideo.cat
C:\home\VirtualBox\virtual-box-windows-guest-additions-installer\additions\vboxmouse.cat

alternativ: makecat mit .cdf - dann ist sicher gestellt welche hashes überhaupt gespeichert werden.

signtool sign /v /s PrivateCertStore /n "Sebastian C. Brandt" /sha1 "4902ee3772f13145740b32c135e0ea872bcb6e38" /t http://timestamp.verisign.com/scripts/timestamp.dll vboxmouse.cat vboxvideo.cat vboxguest.cat


certmgr /add vbox.cer /s /r localMachine root
certmgr.msc

signtool verify /pa /v /c vboxguest.cat VBoxGuest.inf
--> schon besser!


"enable the kernel mode test-signing boot configuration option"
muss das sein, weil selbst-signiert? oder fragt der dann zumindest nach? oder vorher CA installieren?

installation cert in win7/local machine .. nur als admin ...?
cmd -> run as admin
start .cer
phys store
nicth trusted publishers!\Local Computer
funzt aber nicht.


signtool verify /pa /v /c vboxguest.cat VBoxGuest.sys

Verifying: VBoxGuest.sys
File is signed in catalog: vboxguest.cat
SignTool Error: WinVerifyTrust returned error: 0x800B0109
        Eine Zertifikatskette wurde zwar verarbeitet, endete jedoch mit einem Stammzertifikat, das beim Vertrauensanbiet
er nicht als vertrauenswurdig gilt.

Vertrauenswürdige Stammzertifizierungsstellen\Lokaler Computer
gg. vertraute herausgeber?

certmgr /add sbrandt-vbox.cer /s /r localMachine root
warum wird der fingerabdruch bei der installation nicht mehr nachgefragt? nur ab und an ... neuer key?

installation win7 - trusted ca auths!


inf2cat /driver:. /os:2000,XP_X86,Vista_X86,7_X86
signtool sign /v /s PrivateCertStore /n "Sebastian C. Brandt" /sha1 "4902ee3772f13145740b32c135e0ea872bcb6e38" /t http://timestamp.verisign.com/scripts/timestamp.dll vboxmouse.cat vboxvideo.cat vboxguest.cat
signtool verify /pa /v /c vboxguest.cat VBoxGuest.inf