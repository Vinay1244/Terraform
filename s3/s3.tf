provider "aws" {
region = "ap-northeast-1"
}

resource "aws_s3_bucket" "test_s3" {
bucket = "vin-test-s3"
tags = {
Name = "Vinay-bucket"
}
}

resource "aws_s3_bucket_public_access_block" "test_s3_public_access" {
  bucket = aws_s3_bucket.test_s3.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "test_s3_policy" {
  bucket = aws_s3_bucket.test_s3.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowPublicRead"
        Effect    = "Allow"
        Principal = "*"
        Action    = [
          "s3:GetObject"
        ]
        Resource = "${aws_s3_bucket.test_s3.arn}/*"
      }
    ]
  })
  depends_on = [
    aws_s3_bucket_public_access_block.test_s3_public_access
  ]
}

resource "aws_s3_bucket_object" "example_file" {
  bucket = aws_s3_bucket.test_s3.bucket
  key    = "index.html"
  source = "/home/ubuntu/s3/index.html"
}

