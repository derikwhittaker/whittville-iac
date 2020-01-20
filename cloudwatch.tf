
/* MyQ Schedule Setup */
resource "aws_cloudwatch_event_rule" "whittville-sensor-myq-event" {
  name        = "whittville-sensor-myq-event"
  description = "Gather MyQ Sensor Data - 15 min after the hour"

  schedule_expression = "cron(15 */1 * * ? *)"

}

resource "aws_cloudwatch_event_target" "whittville-sensor-myq-event-target" {
  rule      = aws_cloudwatch_event_rule.whittville-sensor-myq-event.name
  target_id = "GatherMyQSensorData"
  arn       = aws_lambda_function.sensor-aggregator.arn
  input     = "{ \"source\": \"cloudwatch\", \"handler\": \"myq\" }"
}

/* Ring Schedule Setup */
resource "aws_cloudwatch_event_rule" "whittville-sensor-ring-event" {
  name        = "whittville-sensor-ring-event"
  description = "Gather Ring Sensor Data - 30 min after the hour"

  schedule_expression = "cron(30 */1 * * ? *)"

}

resource "aws_cloudwatch_event_target" "whittville-sensor-ring-event-target" {
  rule      = aws_cloudwatch_event_rule.whittville-sensor-ring-event.name
  target_id = "GatherRingSensorData"
  arn       = aws_lambda_function.sensor-aggregator.arn
  input     = "{ \"source\": \"cloudwatch\", \"handler\": \"ring\" }"
}

/* Netatmo Schedule Setup */
resource "aws_cloudwatch_event_rule" "whittville-sensor-netatmo-event" {
  name        = "whittville-sensor-netatmo-event"
  description = "Gather Netatmo Sensor Data - 45 min after the hour"

  schedule_expression = "cron(45 */1 * * ? *)"

}

resource "aws_cloudwatch_event_target" "whittville-sensor-netatmo-event-target" {
  rule      = aws_cloudwatch_event_rule.whittville-sensor-netatmo-event.name
  target_id = "GatherNetatmoSensorData"
  arn       = aws_lambda_function.sensor-aggregator.arn
  input     = "{ \"source\": \"cloudwatch\", \"handler\": \"netatmo\" }"
}
