export MASTERIP=$(terraform output -json aws_sandbox-Public-IPs | jq -r '.aws_sandbox_tf_1')
export NODE2IP=$(terraform output -json aws_sandbox-Public-IPs | jq -r '.aws_sandbox_tf_2')