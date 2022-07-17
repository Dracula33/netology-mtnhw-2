resource "local_file" "inventory" {
  content = <<-DOC
---
clickhouse:
  hosts:
    clickhouse-01:
      ansible_host: ${module.test-node.external-ip}
      ansible_user: centos
DOC
  filename = "../inventory/prod.yml"

  depends_on = [
    module.test-node
  ]
}
