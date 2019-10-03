yum install -y epel-release
yum install -y cloud-utils-growpart
cat << EOF > 05-grow-root.sh
#!/bin/sh

/bin/echo
/bin/echo Resizing root filesystem

growpart --fudge 20480 -v /dev/vda 1
e2fsck -f /dev/vda1
resize2fs /dev/vda1
EOF

chmod +x 05-grow-root.sh

dracut --force --include 05-grow-root.sh /mount --install 'echo awk grep fdisk sfdisk growpart partx e2fsck resize2fs' "$(ls /boot/initramfs-*)" $(ls /boot/|grep vmlinuz|sed s/vmlinuz-//g)
rm -f 05-grow-root.sh
