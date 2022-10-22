set -x 
source "/etc/libvirt/hooks/kvm.conf"
rc-service sddm stop
echo 0 > /sys/class/vtconsole/vtcon0/bind
echo 0 > /sys/class/vtconsole/vtcon1/bind
echo "efi-framebuffer.0" > /sys/bus/platform/drivers/efi-framebuffer/unbind
sleep 5


echo -n "0000:09:00.0" > /sys/bus/pci/drivers/amdgpu/unbind
echo -n "0000:09:00.1" > /sys/bus/pci/drivers/snd_hda_intel/unbind
echo -n "0000:08:00.0" > /sys/bus/pci/devices/0000:08:00.0/driver/unbind
echo -n "0000:07:00.0" > /sys/bus/pci/devices/0000:07:00.0/driver/unbind
modprobe -r amdgpu
modprobe -r snd_hda_intel


virsh nodedev-detach $VIRSHGPUV
virsh nodedev-detach $VIRSHGPUA
virsh nodedev-detach $VIRSHGPU1
virsh nodedev-detach $VIRSHGPU2

modprobe vfio
modprobe vfio_pci
modprobe vfio_iommu_type1
