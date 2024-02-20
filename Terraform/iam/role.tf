resource "aws_iam_role" "asm3_role" {
  name               = var.role_name
  assume_role_policy = var.role_assume
}

resource "aws_iam_role_policy_attachment" "policy_attachments" {
  for_each = var.policy_arns

  role       = aws_iam_role.asm3_role.name
  policy_arn = lookup(var.policy_arns, each.key, null)
}

output "asm3_role_arn" {
  value = aws_iam_role.asm3_role.arn
}