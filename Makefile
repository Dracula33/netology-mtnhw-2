
default: run_ansible

all: create_virt run_ansible destroy

create_virt:
	cd ./terraform_host && terraform init
	cd ./terraform_host && terraform validate
	cd ./terraform_host && terraform plan
	cd ./terraform_host && terraform apply -auto-approve
	echo "Still creating" && sleep 30

run_ansible:
	ansible-galaxy install -r ./requirements.yml -p ./roles -f
	ansible-playbook -i inventory/prod.yml site.yml

first_run: create_virt run_ansible

destroy:
	cd ./terraform_host && terraform destroy -auto-approve