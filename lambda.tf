

data "archive_file" "dummy_lambda_archive" {
  type        = "zip"
  source_content = "async function foo(){}; module.exports = { foo }"
  source_content_filename = "index.js"
  output_path = "${path.module}/archive_files/lambda.zip"
}

resource "aws_lambda_function" "sensor-aggregator" {
  filename      = data.archive_file.dummy_lambda_archive.output_path
  function_name = "whittville-sensor-aggregator-nonprod-lambda"
  role          = aws_iam_role.whittville-lamba-role.arn
  handler       = "src/index.handler"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = data.archive_file.dummy_lambda_archive.output_base64sha256

  runtime = "nodejs12.x"
  memory_size = 128
  timeout = 30

  environment {
    variables = {
        log_level = "trace"
        netatmo_sm_key = "nonprod/whittville/netatmo"
        myQ_sm_key = "nonprod/whittville/myq"
        ring_sm_key = "nonprod/whittville/ring"
    }
  }
}


resource "aws_lambda_function" "sensor-consumer" {
  filename      = data.archive_file.dummy_lambda_archive.output_path
  function_name = "whittville-sensor-consumer-nonprod-lambda"
  role          = aws_iam_role.whittville-lamba-role.arn
  handler       = "src/index.handler"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = data.archive_file.dummy_lambda_archive.output_base64sha256

  runtime = "nodejs12.x"
  memory_size = 128
  timeout = 30

  environment {
    variables = {
        log_level = "trace"
    }
  }
}

resource "aws_lambda_function" "sensor-api" {
  filename      = data.archive_file.dummy_lambda_archive.output_path
  function_name = "whittville-sensor-api-nonprod-lambda"
  role          = aws_iam_role.whittville-lamba-role.arn
  handler       = "src/index.handler"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = data.archive_file.dummy_lambda_archive.output_base64sha256

  runtime = "nodejs12.x"
  memory_size = 128
  timeout = 30

  environment {
    variables = {
        log_level = "trace"
    }
  }
}


resource "aws_lambda_permission" "whittville-aggregator-allow-cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sensor-aggregator.function_name
  principal     = "events.amazonaws.com"
}
