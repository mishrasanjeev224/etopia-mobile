#
# EKS Worker Nodes Resources
#  * IAM role allowing Kubernetes actions to access other AWS services
#  * EKS Node Group to launch worker nodes
#

resource "aws_iam_role" "etopia-mobile-node" {
  name = "terraform-eks-etopia-mobile-node"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "etopia-mobile-node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.etopia-mobile-node.name
}

resource "aws_iam_role_policy_attachment" "etopia-mobile-node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.etopia-mobile-node.name
}

resource "aws_iam_role_policy_attachment" "etopia-mobile-node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.etopia-mobile-node.name
}

resource "aws_eks_node_group" "etopia-mobile" {
  cluster_name    = aws_eks_cluster.etopia-mobile.name
  node_group_name = "etopia-mobile"
  node_role_arn   = aws_iam_role.etopia-mobile-node.arn
  subnet_ids      = aws_subnet.etopia-mobile[*].id

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.etopia-mobile-node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.etopia-mobile-node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.etopia-mobile-node-AmazonEC2ContainerRegistryReadOnly,
  ]
}
