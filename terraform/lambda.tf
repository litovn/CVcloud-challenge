resource "aws_iam_role" "lambda_iam_role" {
    name = "lambda_iam_role"
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
        }]
    }
    EOF
}

resource "aws_lambda_function" "visitors_count" {
    filename         = "lambda_func_payload.zip"
    source_code_hash = data.archive_file.lambdapy_zip.output_base64sha256
    function_name    = "visitors_count"
    role             = aws_iam_role.lambda_iam_role.arn
    handler          = "app.lambda_handler"
    runtime          = "python3.10"
}

data "archive_file" "lambdapy_zip" {
    type        = "zip"
    source_file = "${path.root}/../lambda/app.py"
    output_path = "lambda_func_payload.zip"
}

resource "aws_iam_policy" "lambda_exec" {
    name        = "lambda_execution_policy"
    description = "AWS IAM policy for lambda to update DynamoDB table"
    policy = jsonencode(
    {
        "Version" : "2012-10-17",
        "Statement" : [
        {
            "Effect" : "Allow",
            "Action" : [
                "dynamodb:DeleteItem",
                "dynamodb:GetItem",
                "dynamodb:PutItem",
                "dynamodb:Scan",
                "dynamodb:UpdateItem"
            ],
            "Resource" : "arn:aws:dynamodb:*:*:table/cloudcv-views"
        }]
    })
}

resource "aws_iam_role_policy_attachment" "lambda_exec" {
  role       = aws_iam_role.lambda_iam_role.name
  policy_arn = aws_iam_policy.lambda_exec.arn
}

resource "aws_iam_policy" "lambda_log" {
    name        = "lambda_logging_policy"
    description = "AWS IAM policy for lambda to send logs to CloudWatch"
    policy = jsonencode(
    {
        "Version" : "2012-10-17",
        "Statement" : [
        {
            "Effect" : "Allow",
            "Action" : [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource" : "arn:aws:logs:*:*:*"
        }]
    })
}

resource "aws_iam_role_policy_attachment" "lambda_log" {
  role       = aws_iam_role.lambda_iam_role.name
  policy_arn = aws_iam_policy.lambda_log.arn
}

resource "aws_api_gateway_rest_api" "visitors_API" {
  name        = "visitors_API"
  description = "API for counting website visitors"
}

resource "aws_lambda_permission" "visitors_count" {
  statement_id  = "Allow_VisitorsCount_APIInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.visitors_count.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.visitors_count.execution_arn}/*"
}