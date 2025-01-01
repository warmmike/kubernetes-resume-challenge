terraform {
    required_version = ">= 1.5.7"
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = ">= 5.7"
        }
        kubernetes = {
            source = "hashicorp/kubernetes"
            version = ">= 2.3"
        }
    }
}

module "aws_provider" {
    source = "./modules/aws"
    aws_region = var.aws_region
}
