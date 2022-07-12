data "aws_availability_zones" "all" {}

variable "master-node-count" {
  default = 2
}
variable "node-list" {
  type = list
  default = [
    { "10.10.10.10"="k8s-master1" },
    { "10.10.10.11"="k8s-worker1" },
    { "10.10.10.12"="k8s-worker2" },
    { "10.10.10.30"="nfs-ips" },
    { "10.10.10.200"="private-registry" },
  ]
}
variable "ips" {
  default = {
    "0" = "10.10.10.10"
    "1" = "10.10.10.11"
    "2" = "10.10.10.12"
    "3" = "10.10.10.13"
    "4" = "10.10.10.14"
    "5" = "10.10.10.15"
  }
}
variable "names" {
  default = {
    "0" = "k8s-master1"
    "1" = "k8s-master2"
    "2" = "k8s-master3"
    "3" = "k8s-worker1"
    "4" = "k8s-worker2"
    "5" = "k8s-worker3"
  }
}

variable "worker-ips" {
  default = {
    "0" = "10.10.10.20"
    "1" = "10.10.10.21"
    "2" = "10.10.10.22"
    "3" = "10.10.10.23"
    "4" = "10.10.10.24"
    "5" = "10.10.10.25"
  }
}
variable "registry-ips" {
  default = {
    "0" = "10.10.10.200"
  }
}
variable "nfs-ips" {
  default = {
    "0" = "10.10.10.30"
  }
}
data "template_file" "registry-init-script" {
  template = file("./private_registry.sh")
  vars = {
    ip_address= lookup(var.ips,0)
    nfs_address = lookup(var.nfs-ips,0)
    REGISTRY_LOCAL = "/install_image"
    REGISTRY_IP= lookup(var.registry-ips,0)
    REGISTRY_PORT ="5000"
  }
}
data "template_file" "registry-imagepush-script" {
  template = file("./registry_imagepush.sh")
  vars = {
    ip_address= lookup(var.ips,0)
    nfs_address = lookup(var.nfs-ips,0)
    REGISTRY_LOCAL = "/install_image"
    REGISTRY_IP= lookup(var.registry-ips,0)
    REGISTRY_PORT ="5000"
    REGISTRY_INFO="10.10.10.200:5000"
    TFC_VERSION="b5.0.1.0"
    ISTIO_VERSION="1.5.1"
    JAEGER_VERSION="1.16"
    KIALI_VERSION="v1.21"
    HYPERNET_LOCAL_AGENT_VERSION="0.4.2"
    CONSOLE_VERSION="5.0.12.0"
    OPERATOR_VERSION="5.1.0.1"
    HPCD_SINGLE_OPERATOR_VERSION="5.0.10.0"
    HPCD_MULTI_OPERATOR_VERSION="5.0.10.0"
    HPCD_API_SERVER_VERSION="5.0.10.0"
    HPCD_POSTGRES_VERSION="5.0.0.1"
    HPCD_MULTI_AGENT_VERSION="5.0.10.0"
    FED_VERSION="v0.3.0"
    BINARY_VERSION="0.3.0"
    OS_TYPE="linux"
    ARCH_TYPE="amd64"
    KUBE_RBAC_PROXY_VERSION="v0.4.1"
    CAPI_VERSION="v0.3.16"
    AWS_VERSION="v0.6.5"
    VSPHERE_RBAC_PROXY_VERSION="v0.8.0"
    KUBE_VIP_VERSION="0.3.2"
    LIVE_PROBE_VERSION="v2.1.0"
    CSI_ATTACHER_VERSION="v3.0.0"
    CSI_PROVISOINER_VERSION="v2.0.0"
    CSI_REG_VERSION="v2.0.1"
    CSI_DRIVER_VERSION="v2.1.0"
    CSI_SYNCER_VERSION="v2.1.0"
    VSPHERE_VERSION="v0.7.6"
    CERT_MANAGER_VERSION="v1.1.0"
  }
}
data "template_cloudinit_config" "registry-cloudinit" {
  gzip          = false
  base64_encode = false
  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.registry-init-script.rendered
  }
#  part {
#    content_type = "text/x-shellscript"
#    content      = data.template_file.registry-imagepush-script.rendered
#  }
}

data "template_file" "init-script" {
  template = file("./install_nginx.sh")
  vars = {
    #consul_address= join(",", aws_instance.k8s-master.*.private_ip)
    consul_address= "10.10.10.30" #join(",", aws_instance.k8s-master.*.private_ip)
    nfs_address = "10.10.10.30" #join(",",aws_efs_mount_target.master-efs-mt.ip_address)
    #tostring(join(",", aws_instance.k8s-master.*.private_ip))
    #"10.10.10.10"
    #    consul_address = aws_instance.k8s-master.private_ip
  }
}
data "template_cloudinit_config" "cloudinit" {
  gzip          = false
  base64_encode = false
  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.init-script.rendered
  }
}


data "template_file" "runtime-init-script" {
  template = file("./k8s_runtime.sh")
  count=var.master-node-count
  vars = {
    instance_ipaddress="${element(keys(var.node-list[count.index]), 0)}"
    instance_hostname="${element(values(var.node-list[count.index]), 0)}"
    all_host_info=replace(replace(jsonencode(var.node-list), "\"", ""), ":", "=")
    nfs_address=lookup(var.nfs-ips,0)
    k8s_VERSION="1.19"
    REGISTRY_IP= lookup(var.registry-ips,0)
    REGISTRY_PORT ="5000"
  }
}
#data "template_file" "runtime-init-script" {
#  template = file("./k8s_runtime.sh")
#  vars = {
#    instance_ipaddress= lookup(var.registry-ips,0)
#    nfs_address = lookup(var.nfs-ips,0)
#    instance_hostname = lookup(var.names,0)
#    k8s_VERSION="1.19"
#    REGISTRY_IP= lookup(var.registry-ips,0)
#    REGISTRY_PORT ="5000"
#  }
#}
#data "template_cloudinit_config" "runtime-cloudinit" {
#  gzip          = false
#  base64_encode = false
#  part {
#    content_type = "text/x-shellscript"
#    content      = join(",", data.template_file.runtime-init-script.*.rendered)
#  }
#}