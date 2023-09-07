#create S3 bucket for csv objects
resource "aws_s3_bucket" "csv-bucket" {
  bucket = var.csv_bucket_name
}