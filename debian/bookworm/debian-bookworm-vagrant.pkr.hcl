packer {
  required_plugins {
    qemu = {
      source  = "github.com/hashicorp/qemu"
      version = "~> 1"
    }
    vagrant = {
      source  = "github.com/hashicorp/vagrant"
      version = "~> 1"
    }
  }
}

source "qemu" "debian-bookworm" {
  accelerator      = "kvm"
  boot_command     = ["<esc><wait>", "auto ",
                     "preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed-vagrant.cfg ",
                     "hostname=debian-bookworm ",
                     "net.ifnames=0", "<enter>"]
  disk_cache       = "none"
  disk_interface   = "virtio"
  disk_size        = 20480
  format           = "qcow2"
  headless         = "true"
  http_directory   = "."
  iso_checksum     = "sha256:dfc30e04fd095ac2c07e998f145e94bb8f7d3a8eca3a631d2eb012398deae531"
  iso_target_path  = "./debian-12.12.0-amd64-netinst.iso"
  iso_url          = "https://cdimage.debian.org/cdimage/archive/12.12.0/amd64/iso-cd/debian-12.12.0-amd64-netinst.iso"
  memory           = 1024
  net_device       = "virtio-net"
  output_directory = "builddir"
  shutdown_command = "sudo -S poweroff"
  ssh_password     = "vagrant"
  ssh_port         = 22
  ssh_username     = "vagrant"
  ssh_wait_timeout = "30m"
  vm_name          = "debian-bookworm"
}

build {
  sources = ["source.qemu.debian-bookworm"]

  provisioner "shell" {
    execute_command = "sudo -S sh '{{ .Path }}'"
    script          = "conf.sh"
  }

  post-processor "vagrant" {
    output = "debian-bookworm-vagrant-libvirt.box"
  }
}
