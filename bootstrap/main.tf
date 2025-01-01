module "s3" {
    source = "./modules/s3"
    s3_bucket_name = var.s3_bucket_name
}

module "dynamodb" {
    source = "./modules/dynamodb"
    dynamodb_table_name = var.dynamodb_table_name
}
