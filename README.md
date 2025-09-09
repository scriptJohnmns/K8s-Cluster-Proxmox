# Terraformando o Proxmox!

![Terraform](https://img.shields.io/badge/Terraform-1.13.1-purple?style=for-the-badge&logo=terraform&logoColor=white")
![Proxmox](https://img.shields.io/badge/Proxmox_VE-8.0-orange?style=for-the-badge&logo=proxmox&logoColor=white")
![BPG Provider](https://img.shields.io/badge/Provider-BPG%2FProxmox-green?style=for-the-badge)

# Cluster Kubernetes em Proxmox com Terraform e Kubespray (IaC)

![GitHub Actions Workflow Status](https://github.com/SEU-USUARIO/SEU-REPO/actions/workflows/deploy.yml/badge.svg)

Este repositório contém um projeto de Infraestrutura como Código (IaC) para provisionar e configurar um cluster Kubernetes em um ambiente Proxmox VE de forma automatizada.

O projeto utiliza **Terraform** para o provisionamento da infraestrutura, **Kubespray (Ansible)** para a configuração do cluster, e **GitHub Actions** para orquestrar o pipeline de CI/CD. O estado do Terraform é gerenciado remotamente por um servidor **MinIO**.

## Pré-requisitos

Antes de começar, garanta que você tenha os seguintes pré-requisitos:

1.  **Proxmox VE:** Um ambiente Proxmox funcional.
2.  **Template de VM:** Uma VM template (ex: Ubuntu 24.04) com Cloud-Init configurado e `qemu-guest-agent` instalado.
3.  **Servidor MinIO:** Um servidor MinIO acessível pela rede para atuar como backend remoto do Terraform.
4.  **Credenciais:**
    * Um usuário/role no Proxmox com permissões para a API.
    * Um Access Key e Secret Key para o bucket no MinIO.
5.  **Ferramentas Locais:** `terraform` e `git` instalados na sua máquina.

## Configuração do Projeto

#### 1. Clone o Repositório
```bash
git clone [https://github.com/SEU-USUARIO/SEU-REPO.git](https://github.com/SEU-USUARIO/SEU-REPO.git)
cd SEU-REPO
```

#### 2. Variáveis de Infraestrutura (`terraform.tfvars`)
Este arquivo define a topologia e as especificações do seu cluster. [cite_start]Edite o `terraform.tfvars` [cite: 3] para customizar seu ambiente:
```hcl
# Exemplo de terraform.tfvars
disk_datastore      = "vms2"
cloudinit_datastore = "vms2"

masters = {
  "manager1-k8s" = { vm_id=212, cpu_cores=2, memory_mb=4096, disk_size=50, ipv4_address="192.168.18.212/24" }
}

workers = {
  "worker1-k8s"  = { vm_id=215, cpu_cores=1, memory_mb=2048, disk_size=25, ipv4_address="192.168.18.215/24" }
}
```

#### 3. Variáveis de Ambiente e Segredos (`.env`)
Para **execução local**, crie um arquivo `.env` na raiz do projeto. Este arquivo **não deve ser enviado para o Git** (verifique seu `.gitignore`).

**Copie o exemplo abaixo para um novo arquivo `.env` e preencha com seus valores:**
```bash
# Arquivo .env

# Credenciais para o backend do MinIO
export AWS_ACCESS_KEY_ID="SEU_ACCESS_KEY_MINIO"
export AWS_SECRET_ACCESS_KEY="SEU_SECRET_KEY_MINIO"

# Variáveis do Terraform
export TF_VAR_proxmox_endpoint="https://IP_DO_PROXMOX:8006/api2/json"
export TF_VAR_proxmox_user="SEU_USUARIO_PROXMOX"
export TF_VAR_proxmox_password="SUA_SENHA_PROXMOX"
export TF_VAR_node_name="NOME_DO_SEU_NODE_PVE"
export TF_VAR_node_address="IP_DO_SEU_NODE_PVE"
export TF_VAR_base_template_id="ID_DO_SEU_TEMPLATE"
export TF_VAR_network_gateway="IP_DO_SEU_GATEWAY"
export TF_VAR_ssh_public_key='CONTEUDO_DA_SUA_CHAVE_PUBLICA'
```

## Execução Local (Recomendado para Testes)

Siga estes passos para provisionar a infraestrutura a partir da sua máquina.

#### 1. Carregue as Variáveis de Ambiente
No seu terminal, na raiz do projeto, execute:
```bash
source .env
```

#### 2. Inicialize o Terraform
Este comando vai se conectar ao seu backend MinIO.
```bash
terraform init
```

#### 3. Crie a Infraestrutura
```bash
terraform apply
```
Confirme a execução digitando `yes`. Ao final, as VMs estarão criadas e o arquivo `inventory.ini` será gerado na raiz do projeto.

#### 4. Execute o Kubespray (Ansible)
Com a infraestrutura no ar e o inventário pronto, prepare e execute o Kubespray.
```bash
# Crie e ative um ambiente virtual Python
python3 -m venv .venv-kubespray
source .venv-kubespray/bin/activate

# Instale as dependências
pip3 install -r kubespray/requirements.txt

# Execute o playbook
ansible-playbook kubespray/cluster.yml \
  -i inventory.ini \
  --become \
  --private-key ~/.ssh/id_rsa
```

## Automação com GitHub Actions

Para automação completa, o pipeline de CI/CD usa GitHub Secrets.

#### 1. Configuração do Runner Self-Hosted
Este pipeline requer um **runner self-hosted** configurado na sua rede local e com acesso ao Proxmox e MinIO. Certifique-se de que o runner tenha as seguintes ferramentas instaladas: `terraform`, `nodejs`, `python3-venv`.

#### 2. Configuração dos Segredos no GitHub
Vá para **Settings > Secrets and variables > Actions** no seu repositório e cadastre os segredos. Os nomes dos segredos devem ser os que estão no nosso `deploy.yml`, que correspondem às variáveis do arquivo `.env` (sem os prefixos `export` e `TF_VAR_`).

| Variável no `.env` | Nome do Segredo no GitHub |
|:---|:---|
| `AWS_ACCESS_KEY_ID` | `MINIO_ACCESS_KEY` |
| `AWS_SECRET_ACCESS_KEY` | `MINIO_SECRET_KEY` |
| `TF_VAR_proxmox_password` | `PROXMOX_PASSWORD` |
| `TF_VAR_node_name` | `PROXMOX_NODE_NAME` |
| ... e assim por diante para todos os outros. | ... |

#### 3. Executando o Pipeline
* **Criação/Atualização:** Um `git push` para a branch `main` ou um acionamento manual na aba "Actions" com a opção `apply` irá executar o pipeline completo.
* **Destruição:** Acione o pipeline manualmente e escolha a opção `destroy` para apagar toda a infraestrutura gerenciada pelo Terraform.
