variable "aws_region" {
    description = "AWS Region"
    type = string
    default = ""
}

variable "k8s_name" {
  default = "eks"
}

variable "k8s_version" {
  default = "1.31"
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}
variable "private_subnet_cidr_blocks" {
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}
variable "public_subnet_cidr_blocks" {
  default = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "tags" {
  default = {
    App = "eks-cluster"
  }
}
