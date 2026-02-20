resource "aws_iam_role" "this" {

    name = var.iam_role_name
    description = var.iam_role_description
    assume_role_policy = var.assume_role_policy

    # Always true, to force detach policies before destroying. 
    force_detach_policies = true

    max_session_duration = var.assume_role_max_session_duration

    tags = merge(
        var.tags, 
        {
            Name = var.iam_role_name
        }
    )

}


resource "aws_iam_role_policy" "this" {

    name = "${aws_iam_role.this.name}-policy"

    policy = var.iam_role_policy

    role = aws_iam_role.this.id
  
}