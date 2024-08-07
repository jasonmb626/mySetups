# Show how to restore Fedora Boot loader in a Win 11/Fedora Dual boot scenario

Install Win 11
(For the purposes of tutorial used virtmanager and the Windows 11 install steps shown here https://www.youtube.com/watch?v=7tqKBy9r9b4&t=1198s)
Fedora (Most recently Fedora 40) on same drive.

System should be dual booting as intended, but I've had Windows updates restore the Windows boot loader and Grub dissapears.

## For tutorial/practice only -- Force Restoration of Windows boot loader

Boot from Win 11 Installation/Recovery Media

Instead of choosing install, choose Repair your computer. Choose Troubleshoot, then Command Prompt

### If in virtmanager load the virtio-win ISO in a second DVD device and follow the below steps to install the virtio storage drivers so that the drive can be accessed.

```sh
E:\
cd \viostor\w11\amd64
drvload viostor.inf
```

C:\ should now have your Windows drive
If on actual hardware or in Virtualbox skip the above step.

Now verify we can see the disk

### Now force restoration

```
DISKPART> list disk

 Disk ###  Status          Size      Free    Dyn  Gpt
 -------- ---------------  --------  ------- ---  ---
 Disk 0   Online            128 GB      0 B        *

sel disk 0

list vol

 Volume ###  Ltr  Label        Fs      Type         Size       Status    Info
 ----------  ---  -----------  ----    ----------   --------   --------  ---------
 Volume 0     D   CCCOMA_X64F  UDF     CD-ROM       6497 MB    Healthy
 Volume 1     E   virtio-win-  CDFS    CD-ROM        598 MB    Healthy
 Volume 2     C                NTFS    Partition      99 GB    Healthy
 Volume 3                      Fat 32  Partition     100 MB    Healthy   Hidden
 Volume 4                      NTFS    Partition     768 MB    Healthy   Hidden

sel vol 3
assign letter=f
exit
f:\
cd EFI\Microsoft\Boot
REN BCD BCD.BAK
bdcboot C:\Windows /l en-us /s f: /f ALL
boortec /rebuildbcd
```

The Microsoft Booloader is restored.

# The real purpose of this tutorial -- Restoring the Fedora Grub Menu

Boot from Fedora Live Installation/recovery media. Open a terminal.

```
$ lsblk
NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
...
vda    252:0    0   128G  0 disk
├─vda1 252:1    0   100M  0 part /boot/efi
├─vda2 252:2    0    16M  0 part
├─vda3 252:3    0  99.1G  0 part
├─vda4 252:4    0   768M  0 part
├─vda5 252:5    0     1G  0 part /boot
└─vda6 252:6    0    27G  0 part /home
                                 /
```

Assuming a configuration like the above:
/dev/vda6 has your home and root folders, and vda1 is the 100mb Windows-created EFI

On real hardware the device will likely be /dev/sda or /dev/nvme0n1 etc

Adjust (if necessary) the options -d /dev/vda and -p 1 to point to the filesystem which Fedora mounts at /boot/efi (an EFI system partition).
The above uses partition number 1 on /dev/vda.
(The Fedora installer will have created a dedicated ESP for your Fedora install to use, separate from the ESPs used by any other operating system.)

Prepare the below commands in a text editor and adjust the values ahead of time if necessary.

```sh
#Prepare the environment
sudo mount /dev/vda6 /mnt
sudo mount /dev/vda1 /mnt/root/boot
for i in /dev /dev/pts /proc /sys /run; do sudo mount -B $i /mnt/root$i; done
sudo chroot /mnt/root
mount -t efivarfs efivarfs /sys/firmware/efi/efivars

#This step actually restores the Grub menu
sudo efibootmgr -c -L Fedora -d /dev/vda -p 1 -l \\EFI\\fedora\\shim.efi
```

Now shutdown, remove installation media, and start up again. Fedora Grub Menu is back.
