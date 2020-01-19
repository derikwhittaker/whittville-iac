resource "aws_sns_topic" "whittville-sns" {
  name = "whittville-sns-topic"
}

// Setup SNS Topic Subscription

resource "aws_sns_topic_subscription" "lambda-sensor-consumer-subscription" {
  depends_on = ["aws_lambda_function.sensor-consumer"]
  topic_arn = aws_sns_topic.whittville-sns.arn
  protocol = "lambda"
  endpoint = aws_lambda_function.sensor-consumer.arn
}