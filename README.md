# qemu-kvm-gpu-passthrough
My pcie passthrough setup for a windows 10/11 vm. Included XML file and hook scripts.

![VMM settings](https://github.com/user-attachments/assets/3f763095-0788-4b88-8c04-bdfa65e6b02d)

Works on amd ryzen 5 5600x / radeon rx 6650xt, so it should work on similar hardware 

- Optimizations including CPU pinning, isolation, governor, and hyperv features (Ram hugepages not included because i already have enough ram / startup time isn't worth it)
- Included smbios imformation from my host PC
- my SATA passthrough is not ideal as I was also dualbooting at the time (involves making ext4 partition then passing it. Results in nested disk)
- Passed through two other PCI devices that are built in to the motherboard (AMD cpu's only)
  - 0b:00.3 - `Starship/Matisse HD Audio Controller`
  - 0b:00.4 - `Matisse USB 3.0 Host Controller`
- Motherboard USB 3.0 works but 2.0 and Gen 2 devices need to be passed separately.

Enable IOMMU and SVM in your bios (make sure it's updated!). You may also have to disable resizable BAR in bios to prevent black screening.

The iommu_pci_check.sh script shows all the pci devices, choose only the relevant ones for your graphics card + any others you want in your VM. For reference, here is my relevant IOMMU id's for my graphics card.

```
IOMMU Group 16:
        07:00.0 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD/ATI] Navi 10 XL Upstream Port of PCI Express Switch [1002:1478] (rev c1)
IOMMU Group 17:
        08:00.0 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD/ATI] Navi 10 XL Downstream Port of PCI Express Switch [1002:1479]
IOMMU Group 18:
        09:00.0 VGA compatible controller [0300]: Advanced Micro Devices, Inc. [AMD/ATI] Navi 23 [Radeon RX 6650 XT] [1002:73ef] (rev c1)
IOMMU Group 19:
        09:00.1 Audio device [0403]: Advanced Micro Devices, Inc. [AMD/ATI] Navi 21/23 HDMI/DP Audio Controller [1002:ab28]
```
Do this AFTER you completely install Windows. 

[virtio drivers](https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/) - Needed for Windows to recognize virtio disks during install, unless if you are passing a whole disk partition. Do not install spice drivers! 

## Extra install notes for arch users

 Install the packages needed
 
 ```yay -S qemu-full libvirt edk2-ovmf virt-manager virt-viewer vde2 bridge-utils ebtables dnsmasq swtpm libguestfs```
 
 Enable libvirt and virtlogd
 
 ```sudo systemctl enable --now libvirtd ; sudo systemctl enable --now virtlogd```

Enable the QEMU virtual network 

 ```sudo virsh net-autostart default ; sudo virsh net-start default```
 
 Edit /etc/libvirt/libvirtd.conf and uncomment lines 85, 95, and 108. Lines below if you can't find them
 
 ```
 unix_sock_group = "libvirt"
 unix_sock_ro_perms = "0777"
 unix_sock_rw_perms = "0770"
 ```
 
 Add yourself to libvirt group then restart the service
 
 ```
 sudo usermod -aG libvirt [YOUR USER]
 sudo systemctl restart libvirtd
 ```

## How to dump your vbios
Search for it with find

```
find /sys/devices -name rom
```

Multiple results? Compare id's with your iommu dump for your GPU. For me it was the first one (09:00.0)

![image](https://user-images.githubusercontent.com/78610949/233873069-f7824437-438d-4177-bb7f-f96aaf65a8b6.png)

Now cd to the directory that has the rom and tee it, so you can copy the vbios

```echo 1 | sudo tee rom```

Now copy it to your preferred location

```sudo cp rom /etc/libvirt/YourGPU.rom```
## How to access storage
Use losetup to mount the partition as a loop disk
```
losetup --partscan /dev/loop0 /dev/sdb1
```
Unmount the disk using this command. You need to do this before you run unless if you like wasting time reinstalling windows again
```
losetup --detach /dev/loop0
```

## Further issues / fixes
Try editing your /etc/default/grub and add these options to GRUB_CMDLINE_LINUX_DEFAULT:`amd_iommu=on iommu=pt iommu=1 video=efifb:off disable_idle_d3=1`

Run `chmod +x` on the exec scrpts, including `qemu` and everything on `/etc/libvirt/hooks/qemu.d/win11`

If running the VM boots you back into your display manager, it means your VM had crashed. Figure out the issue by looking through the logs at `/var/log/libvirt/qemu/win11.log`
>[!TIP]
> If you have an issue where it cannot find your rom file, try adding a cdrom device with the rom file like this:
> ```
><disk type="file" device="cdrom">
>  <driver name="qemu" type="raw"/>
>  <source file="/etc/libvirt/YourGPU.rom"/>
>  <target dev="sdb" bus="sata"/>
>  <readonly/>
></disk>
> ```
