#create lambda function
resource "aws_lambda_function" "csv_to_json_lambda" {
  filename      = "lambda_function_payload.zip"
  function_name = var.lambda_function_name
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "lambda_function.lambda_handler"

  source_code_hash = data.archive_file.lambda-function.output_base64sha256

  runtime = "python3.9"
  timeout = 3

  #depends_on = [
    #aws_iam_role_policy_attachment.lambda_logs,
    #aws_cloudwatch_log_group.CSV_to_JSON-function-log-group,
  #]
}

#create lambda permission resource
resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromJSON-S3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.csv_to_json_lambda.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.json-bucket.arn
}