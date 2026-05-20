# kms.tf

# Creates the unique KMS key for the current environment
resource "aws_kms_key" "app_key" {
  description             = "KMS key for Deep Researcher - ${var.environment}"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = {
    Name        = "deep-researcher-key-${var.environment}"
    Environment = var.environment
  }
}

# Creates a friendly alias for the key (e.g., alias/deep-researcher-dev)
resource "aws_kms_alias" "app_key_alias" {
  name          = "alias/deep-researcher-${var.environment}"
  target_key_id = aws_kms_key.app_key.key_id
}
