resource "aws_iam_role" "whittville-lamba-role" {
  name = "whittville-lambda-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "lambda-secret-manager-access" {
  name        = "lambda-secret-manager-access-policy"
  path        = "/"
  description = "Lambda Secret Manager Access"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "secretsmanager:Describe*",
                "secretsmanager:Get*",
                "secretsmanager:List*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "lambda-dynamo-access" {
  name        = "lambda-dynamo-access-policy"
  path        = "/"
  description = "Lambda Dynamo Access"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "dynamodb:DescribeReservedCapacityOfferings",
                "dynamodb:TagResource",
                "dynamodb:UntagResource",
                "dynamodb:ListTables",
                "dynamodb:DescribeReservedCapacity",
                "dynamodb:ListBackups",
                "dynamodb:PurchaseReservedCapacityOfferings",
                "dynamodb:ListTagsOfResource",
                "dynamodb:DescribeTimeToLive",
                "dynamodb:DescribeLimits",
                "dynamodb:ListStreams"
            ],
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": "dynamodb:*",
            "Resource": "arn:aws:dynamodb:*:*:table/*"
        },
        {
            "Sid": "VisualEditor2",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:*:*:*"
        }
    ]
}
EOF
}


resource "aws_iam_policy" "lambda-sns-access" {
  name        = "lambda-sns-access-policy"
  path        = "/"
  description = "Lambda SNS Access"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "sns:Publish",
                "sns:Unsubscribe",
                "sns:Subscribe"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "whittville-lambda-sm-attachment" {
  role       = aws_iam_role.whittville-lamba-role.name
  policy_arn = aws_iam_policy.lambda-secret-manager-access.arn
}

resource "aws_iam_role_policy_attachment" "whittville-lambda-dynamo-attachment" {
  role       = aws_iam_role.whittville-lamba-role.name
  policy_arn = aws_iam_policy.lambda-dynamo-access.arn
}

resource "aws_iam_role_policy_attachment" "whittville-lambda-sns-attachment" {
  role       = aws_iam_role.whittville-lamba-role.name
  policy_arn = aws_iam_policy.lambda-sns-access.arn
}