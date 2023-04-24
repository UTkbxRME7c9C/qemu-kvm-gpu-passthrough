# qemu-kvm-gpu-passthrough
My pcie passthrough setup for a windows 10/11 vm

Works on amd ryzen 5 5600x / radeon rx 6650xt, so it should work on similar hardware

Enable IOMMU in your bios. You may also have to disable resizable BAR in bios to prevent black screening.

etc.libvirt is for directory /etc/libvirt/. The included XML file also includes optimizations such as CPU pinning.

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

## Extra install notes for arch users

 Install the packages needed
 
 ```yay -S qemu-full libvirt edk2-ovmf virt-manager virt-viewer vde2 bridge-utils ebtables dnsmasq libguestfs```
 
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

```echo 1 | sudo tee .```

Now copy it to your preferred location

```sudo cp rom /etc/libvirt/YourGPU.rom```


