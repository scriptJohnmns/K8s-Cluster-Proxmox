# Arquivo: backend.tf

terraform {
  backend "s3" {   
    bucket   = "k8s-terraform-state"  
    key      = "terraform.tfstate"   
    region   = "placeholder"
    
    endpoints = {
      s3 = "http://192.168.18.211:9000"
    }
        

    # 5. Configurações essenciais para MinIO... uns skips...
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    force_path_style            = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
  }
}