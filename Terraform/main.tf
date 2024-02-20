module "asm3_redshift_role" {
  source      = "./iam"
  role_name   = var.asm3_role_name
  role_assume = var.role_assume
  policy_arns = var.policy_arns
}

module "network" {
  source            = "./network"
  provider_region   = var.provider_region
  vpc_cidr          = var.vpc_cidr
  subnet            = [var.subnet[0]]
  availability_zone = [var.availability_zone]
}

module "s3" {
  source         = "./s3"
  data_uploading = var.data_uploading
}

# Provision a resource for redshift_serverless

# resource "aws_redshiftserverless_namespace" "asm3_redshift_serverless" {
#   namespace_name = var.redshift_cluster_name
#   admin_username = var.master_username
#   admin_user_password = var.master_password
#   db_name = var.database_name
#   default_iam_role_arn = module.asm3_redshift_role.asm3_role_arn
#   iam_roles = [module.asm3_redshift_role.asm3_role_arn]
# }

# resource "aws_redshiftserverless_endpoint_access" "asm3_redshift_serverless_endpoint" {
#   endpoint_name = "asm3-redshift-serverless"
#   workgroup_name = aws_redshiftserverless_workgroup.asm3_redshift_serverless_workgroup.id
#   subnet_ids = [module.network.asm3_subnet_id]
# }

# resource "aws_redshiftserverless_workgroup" "asm3_redshift_serverless_workgroup" {
#   namespace_name = aws_redshiftserverless_namespace.asm3_redshift_serverless.id
#   workgroup_name = "asm3-redshift-serverless-workgroup"
#   port = var.port
#   security_group_ids = [module.network.asm3_security_group_redshift]
#   publicly_accessible = var.publicly_accessible
#   subnet_ids = [module.network.asm3_subnet_id]
# }

# Provision resource for redshift_cluster

resource "aws_redshift_cluster" "asm3_redshift_cluster" {
  cluster_identifier        = var.redshift_cluster_name
  database_name             = var.database_name
  master_username           = var.master_username
  master_password           = var.master_password
  cluster_type              = var.cluster_type
  node_type                 = var.node_type
  availability_zone         = var.availability_zone
  port                      = var.port
  allow_version_upgrade     = var.allow_version_upgrade
  number_of_nodes           = var.number_of_nodes
  publicly_accessible       = var.publicly_accessible
  default_iam_role_arn      = module.asm3_redshift_role.asm3_role_arn
  vpc_security_group_ids    = [module.network.asm3_security_group_redshift]
  cluster_subnet_group_name = aws_redshift_subnet_group.asm3_redshift_subnet.name
  iam_roles                 = [module.asm3_redshift_role.asm3_role_arn]
}

resource "aws_redshift_subnet_group" "asm3_redshift_subnet" {
  name       = "asm3-subnet-group"
  subnet_ids = [module.network.asm3_subnet_id]
}

# Provision resource for instance running SCT

# resource "aws_instance" "asm3_sct_instance" {
#   ami = "ami-0adcf082d85f6a445"
#   associate_public_ip_address = true
#   subnet_id = module.network.asm3_subnet_id
#   instance_type = "t2.micro"
#   key_name = "asm2"
#   vpc_security_group_ids = [
#     module.network.asm3_security_group_sct
#   ]
# }
