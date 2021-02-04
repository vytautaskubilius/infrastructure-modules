data "aws_iam_policy_document" "bucket_policy" {
  count = length(var.subdomains)

  version = "2012-10-17"
  statement {
    sid    = "AllowCloudFrontOAIAccess"
    effect = "Allow"
    principals {
      identifiers = [aws_cloudfront_origin_access_identity.oai.iam_arn]
      type        = "AWS"
    }
    actions = [
      "s3:GetObject"
    ]
    resources = ["${aws_s3_bucket.subdomains[count.index].arn}/*"]
  }
}