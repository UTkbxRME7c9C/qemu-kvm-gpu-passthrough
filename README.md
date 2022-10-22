# qemu-kvm-gpu-passthrough
my pcie passthrough setup for windows 10/11
working on amd ryzen 5 5600x / radeon rx 6650xt

used but may be optional https://github.com/gnif/vendor-reset/
disable resizeable rom on bios

etc.libvirt is for directory /etc/libvirt/

explanation for kvm.conf:
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
![alt text][logo]

[logo]: https://raw.githubusercontent.com/awwmbCPmM9Q7xFfM/qemu-kvm-gpu-passthrough/main/image.png
