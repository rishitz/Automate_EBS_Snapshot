resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}


resource "aws_iam_policy" "lambda_exec_policy" {
  name        = "lambda_exec_policy"
  description = "IAM policy for Lambda execution to log to CloudWatch and access other AWS services"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:CreateSnapshot",
          "ec2:DescribeVolumes"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : "sns:Publish",
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : "*"
      }
    ]

  })
}

# Attach the policy to the Lambda IAM role
resource "aws_iam_role_policy_attachment" "lambda_exec_policy_attachment" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.lambda_exec_policy.arn
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/script.py"
  output_path = "script.zip"
}

resource "aws_lambda_function" "name" {
  function_name = "ens-snapshot"
  filename      = "script.zip"
  runtime       = "python3.12"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "script.lambda_handler"
}