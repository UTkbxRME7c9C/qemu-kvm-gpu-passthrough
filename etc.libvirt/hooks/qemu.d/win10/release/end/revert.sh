set -x
source "/etc/libvirt/hooks/kvm.conf"
modprobe -r vfio
modprobe -r vfio_pci
modprobe -r vfio_iommu_type1

virsh nodedev-reattach $VIRSHGPUV
virsh nodedev-reattach $VIRSHGPUA
virsh nodedev-reattach $VIRSHGPU1
virsh nodedev-reattach $VIRSHGPU2

echo 1 > /sys/class/vtconsole/vtcon0/bind
echo 1 > /sys/class/vtconsole/vtcon1/bind

echo "efi-framebuffer.0" > /sys/bus/platform/drivers/efi-framebuffer/unbind

echo -n "0000:09:00.0" > /sys/bus/pci/drivers/amdgpu/unbind
echo -n "0000:09:00.1" > /sys/bus/pci/drivers/snd_hda_intel/unbind
echo -n "0000:08:00.0" > /sys/bus/pci/devices/0000:08:00.0/driver/unbind
echo -n "0000:07:00.0" > /sys/bus/pci/devices/0000:07:00.0/driver/unbind
modprobe amdgpu
modprobe snd_hda_intel

rc-service sddm start




