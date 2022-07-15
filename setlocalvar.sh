k8smasterip=$(terraform output -json aws_sandbox-Public-IPs | jq -r '.aws_sandbox_tf_1')
k8snode2ip=$(terraform output -json aws_sandbox-Public-IPs | jq -r '.aws_sandbox_tf_2')