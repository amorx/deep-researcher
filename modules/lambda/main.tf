# modules/lambda/main.tf

variable "environment_name" {
  type        = string
  description = "The name of the environment (dev, uat, prod)"
}

variable "lambda_zip_path" {
  type        = string
  description = "The local path on the runner to the compiled Lambda zip package"
}

# ⚙️ This variable lets us progressively scale memory without changing the code
variable "lambda_memory_size" {
  type        = number
  description = "Amount of memory in MB for the Lambda function"
}

# 🖥️ This variable lets us toggle features progressively
variable "enable_advanced_logging" {
  type        = bool
  description = "Toggle verbose debugging logs"
}

resource "aws_lambda_function" "research_engine" {
  function_name    = "deep-researcher-engine-${var.environment_name}"
  filename         = var.lambda_zip_path
  source_code_hash = filebase64sha256(var.lambda_zip_path) # 🔄 Tells AWS if the code changed
  handler          = "index.handler"                      # Points to the entry function
  runtime          = "nodejs20.x"                         # Or python3.12 depending on your language
  role             = aws_iam_role.lambda_execution_role.arn
##  timeout          = 300                                  # 5 minutes for deep research tasks

# 🎯 Consistent setup, but parameterized scale
  memory_size   = var.lambda_memory_size

  environment {
    variables = {
      ENV = var.environment_name
      DEBUG_LOGS   = var.enable_advanced_logging ? "true" : "false"
    })
  }
}
