resource "local_file" "inventory" {
  content = <<-DOC
---
clickhouse:
  hosts:
    clickhouse-01:
      ansible_host: ${module.clickhouse.external-ip}
      ansible_user: centos

vector:
  hosts:
    vector-01:
      ansible_host: ${module.vector.external-ip}
      ansible_user: centos

lighthouse:
  hosts:
    lighthouse-01:
      ansible_host: ${module.lighthouse.external-ip}
      ansible_user: centos
DOC
  filename = "../inventory/prod.yml"

  depends_on = [
    module.clickhouse,
    module.vector,
    module.lighthouse
  ]
}
