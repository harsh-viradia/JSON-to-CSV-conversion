#create S3 bucket notification resource to trigger lambda function
resource "aws_s3_bucket_notification" "json_bucket_trigger_lambda" {
  bucket = aws_s3_bucket.json-bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.csv_to_json_lambda.arn
    events              = ["s3:ObjectCreated:*"]
    #filter_prefix      = "AWSLogs/"
    filter_suffix       = ".json"
  }

  depends_on = [aws_lambda_permission.allow_bucket]
}

#create sns topic for csv conversion complete
resource "aws_sns_topic" "conversion_complete_topic" {
  name   = var.sns_topic_name
  display_name = "CSV-File-Ready-TF"
  policy = data.aws_iam_policy_document.json_bucket_topic.json
}

#create sns trigger for csv bucket
resource "aws_s3_bucket_notification" "csv_bucket_trigger_sns" {
  bucket = aws_s3_bucket.csv-bucket.id

  topic {
    topic_arn     = aws_sns_topic.conversion_complete_topic.arn
    events        = ["s3:ObjectCreated:*"]
    #filter_suffix = ".csv"
  }
}

#create subscription for email
resource "aws_sns_topic_subscription" "email_target" {
  topic_arn = "arn:aws:sns:us-east-1:380255901104:JSON_to_CSV_conversion_complete" 
  protocol  = "email"
  endpoint  = "onibabajide34@gmail.com"
}