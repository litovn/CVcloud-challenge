resource "aws_apigatewayv2_api" "visitors_count" {
  name          = "countvisits-api"
  protocol_type = "HTTP"
  cors_configuration {
    allow_origins = ["https://resume.nlitovchenko.eu"]
  }
}

resource "aws_apigatewayv2_integration" "visitors_count" {
  api_id           = aws_apigatewayv2_api.visitors_count.id
  integration_type = "AWS_PROXY"
  description        = "Lambda visitors count."
  integration_method = "POST"
  integration_uri    = aws_lambda_function.visitors_count.invoke_arn
}

resource "aws_apigatewayv2_route" "visitors_count" {
  api_id    = aws_apigatewayv2_api.visitors_count.id
  route_key = "GET /visitorCount"
  target    = "integrations/${aws_apigatewayv2_integration.visitors_count.id}"
}

resource "aws_apigatewayv2_stage" "visitors_count" {
  api_id      = aws_apigatewayv2_api.visitors_count.id
  name        = "v1"
  auto_deploy = "true"
  route_settings {
    route_key              = aws_apigatewayv2_route.visitors_count.route_key
    throttling_burst_limit = "100"
    throttling_rate_limit  = "50"
  }
}

output "invoke_url" {
  value = aws_apigatewayv2_stage.visitors_count.invoke_url
}
output "api_uri" {
  value = aws_apigatewayv2_api.visitors_count.api_endpoint
}

output "api_id" {
  value = aws_apigatewayv2_api.visitors_count.id
}

output "api_route" {
  value = aws_apigatewayv2_route.visitors_count.route_key
}