# swaggy-shopify-app lambda function resources
resource "aws_iam_role" "lambda" {
  name               = "app-lambda-role"
  assume_role_policy = "{\"Version\": \"2012-10-17\", \"Statement\": [{\"Sid\": \"\", \"Effect\": \"Allow\", \"Principal\": {\"Service\": \"lambda.amazonaws.com\"}, \"Action\": \"sts:AssumeRole\"}]}"
}

resource "aws_iam_role_policy" "lambda" {
  name   = "app-lambda-role-policy"
  policy = "{\"Version\": \"2012-10-17\", \"Statement\": [{\"Effect\": \"Allow\", \"Action\": [\"logs:CreateLogGroup\", \"logs:CreateLogStream\", \"logs:PutLogEvents\"], \"Resource\": \"arn:*:logs:*:*:*\"}, {\"Effect\": \"Allow\", \"Action\": [\"ec2:CreateNetworkInterface\", \"ec2:DescribeNetworkInterfaces\", \"ec2:DetachNetworkInterface\", \"ec2:DeleteNetworkInterface\"], \"Resource\": \"*\"}, {\"Effect\": \"Allow\", \"Action\": [\"ec2:CreateNetworkInterface\", \"ec2:DescribeNetworkInterfaces\", \"ec2:DetachNetworkInterface\", \"ec2:DeleteNetworkInterface\"], \"Resource\": \"*\"}]}"
  role   = aws_iam_role.lambda.id
}

resource "aws_lambda_function" "my_app" {

  function_name = "my-app"
  description   = "My helpful app description"
  role          = aws_iam_role.lambda.arn
  memory_size   = 1024
  timeout       = 60
  package_type  = "Image"
  image_uri     = "XXXXXXX.dkr.ecr.us-east-2.amazonaws.com/my-app:YYYYYYYYYYYY"

  image_config {
    command = ["lambda.handler"]
  }

  environment {
    variables = {
      NODE_ENV           = "production"
      PORT               = "8081"
      HOST               = "https://some.host.com"
      SHOPIFY_API_KEY    = "ZZZZZZZZZZZZZZZZ"
      SHOPIFY_API_SECRET = "YYYYYYY"
      SCOPES             = "write_products"
    }
  }
}
