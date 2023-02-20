# S3 bucket for website
resource "aws_s3_bucket" "www" {
  bucket = var.bucket_name
   acl   = "public-read"
  #policy = templatefile("templates/s3-policy.json", { bucket = "$ aws_s3_bucket}" })
}
resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.www.id
  policy = templatefile("templates/s3-policy.json", { bucket = "${var.bucket_name}" })
}
# resource "aws_s3_bucket_cors_configuration" "CorsEx" {
#   bucket = aws_s3_bucket.www.id
#   cors_rule {
#     allowed_headers = ["Authorization", "Content-Length"]
#     allowed_methods = ["GET", "POST"]
#     allowed_origins = ["https://www.${var.www_domain_name}"]
#     max_age_seconds = 3000
#   }
# }
resource "aws_s3_bucket_acl" "ACLEx" {
  bucket = aws_s3_bucket.www.id
   acl   = "public-read" 
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.www.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_website_configuration" "webconfig" {
  bucket = aws_s3_bucket.www.id
  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

  # routing_rule {
  #   condition {
  #     key_prefix_equals = "docs/"
  #   }
  #   redirect {
  #     replace_key_prefix_with = "documents/"
  #   }
  # }
}
 