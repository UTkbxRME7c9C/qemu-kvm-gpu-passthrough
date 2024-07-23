set -x
source "/etc/libvirt/hooks/kvm.conf"

systemctl set-property --runtime -- system.slice AllowedCPUs=0-11
systemctl set-property --runtime -- user.slice AllowedCPUs=0-11
systemctl set-property --runtime -- init.scope AllowedCPUs=0-11

modprobe -r vfio
modprobe -r vfio_pci
modprobe -r vfio_iommu_type1

virsh nodedev-reattach $VIRSHGPUV
virsh nodedev-reattach $VIRSHGPUA
virsh nodedev-reattach $VIRSHGPU1
virsh nodedev-reattach $VIRSHGPU2
modprobe amdgpu
modprobe snd_hda_intel

echo -n "0000:09:00.0" > /sys/bus/pci/drivers/amdgpu/bind
echo -n "0000:09:00.1" > /sys/bus/pci/drivers/snd_hda_intel/bind
echo -n "0000:08:00.0" > /sys/bus/pci/devices/0000:08:00.0/driver/bind
echo -n "0000:07:00.0" > /sys/bus/pci/devices/0000:07:00.0/driver/bind
sleep 5
echo "efi-framebuffer.0" > /sys/bus/platform/drivers/efi-framebuffer/bind

echo 1 > /sys/class/vtconsole/vtcon0/bind
echo 1 > /sys/class/vtconsole/vtcon1/bind
 
systemctl start display-manager
