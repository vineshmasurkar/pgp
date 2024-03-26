provider "aws" {
  region = "us-east-1"
}

variable "pgp_ami" {
  type = string
  default = "ami-06d5e0de6baf595ca"
}