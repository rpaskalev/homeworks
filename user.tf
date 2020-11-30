resource "aws_iam_user" "hamid" {
  name = "hamid"
  path = "/system/"
  tags = {
    tag-key = "tag-value"
  }
}

resource "aws_iam_access_key" "lb" {
  user = "${aws_iam_user.hamid.name}"
}

resource "aws_iam_user_policy" "kms" {
  name = "kms_access"
  user = "${aws_iam_user.hamid.name}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "kms:*",
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": [
         "*"
        ]
    }
  ]
}
EOF
}

data "aws_iam_policy" "example" {
  arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_user_policy_attachment" "test-attach" {
  user       = aws_iam_user.hamid.name
  policy_arn = data.aws_iam_policy.example.arn
}