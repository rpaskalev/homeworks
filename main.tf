provider "aws" {
  region = "us-east-1"
}

resource "aws_kms_key" "Hamid_key" {}

resource "aws_kms_alias" "user1" {
  name          = "alias/my-key-alias"
  target_key_id = "${aws_kms_key.Hamid_key.key_id}"
}

resource "aws_s3_bucket" "kms_bucket" {
  bucket = "rady-1981-02"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.Hamid_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
  provisioner "local-exec" {
    command = "aws s3 cp main.tf s3://rady-1981-02/main.tf --acl public-read"
  }

    provisioner "local-exec" {
    when    = destroy
    command = "aws s3api delete-object --bucket rady-1981-02 --key main.tf"
  }
}
