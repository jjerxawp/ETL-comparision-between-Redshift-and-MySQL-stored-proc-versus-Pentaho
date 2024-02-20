
# NETWORK

variable "provider_region" {
  type    = string
  default = "ap-southeast-1"
  # default = null
  description = "required at the provider declaration"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
  type    = string
  # default = null
  description = "CIDR ip reservation for the VPC"
}

variable "subnet" {
  type = list(string)
  # default = []
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24"]
  description = "CIDR IP reservation for the subnet"
}

# IAM Role


variable "asm3_role_name" {
  default = "asm3_redshift_role"
}

variable "role_assume" {
  default = <<EOF
{
  "Version"               : "2012-10-17",
  "Statement" : [
    {
      "Effect"    : "Allow",
      "Principal" : {
        "Service" : "redshift.amazonaws.com"
      },
      "Action"    : "sts:AssumeRole"
    }
  ]
}
EOF
}

variable "policy_arns" {
  type = map(string)
  default = {
    s3_full_access     = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
    glue_full_access   = "arn:aws:iam::aws:policy/AWSGlueConsoleFullAccess"
    athena_full_access = "arn:aws:iam::aws:policy/AmazonAthenaFullAccess"
  }
}


# Redshift

variable "redshift_cluster_name" {
  default = "asm3-redshift-cluster"
}

variable "database_name" {
  default = "asm3_redshift"
}

variable "master_username" {
  sensitive = false
  default   = "asm3user"
}

variable "master_password" {
  sensitive = false
  default   = "ASM3.password"
}

variable "node_type" {
  default = "dc2.large"
}

variable "cluster_type" {
  default = "single-node"
}

variable "availability_zone" {
  default = "ap-southeast-1a"
}

variable "port" {
  default = 5439
}

variable "allow_version_upgrade" {
  default = false
}

variable "number_of_nodes" {
  default = 1
}

variable "publicly_accessible" {
  default = true
}

# S3

variable "data_uploading" {
  type = map(any)
  default = {
    "fact_netflix_shows.csv" = "../data_export/fact_netflix_shows.csv"
    "netflix_shows.csv"      = "../datasource/netflix_titles.csv"
    "extra_data.csv"         = "../datasource/extra_data.csv"
    "dim_country_noid.csv"   = "../data_export/dim_country_noid.csv"
    "dim_date_noid.csv"      = "../data_export/dim_date_noid.csv"
    "dim_director_noid.csv"  = "../data_export/dim_director_noid.csv"
    "dim_duration_noid.csv"  = "../data_export/dim_duration_noid.csv"
    "dim_info_noid.csv"      = "../data_export/dim_info_noid.csv"
    "dim_rating_noid.csv"    = "../data_export/dim_rating_noid.csv"
    "dim_type_noid.csv"      = "../data_export/dim_type_noid.csv"
  }
}


