export MASTERIP=$(terraform output -json aws_sandbox-Public-IPs | jq -r '.aws_sandbox_tf_1')
export NODE2IP=$(terraform output -json aws_sandbox-Public-IPs | jq -r '.aws_sandbox_tf_2')
export NODE3IP=$(terraform output -json aws_sandbox-Public-IPs | jq -r '.aws_sandbox_tf_3')
export NODE4IP=$(terraform output -json aws_sandbox-Public-IPs | jq -r '.aws_sandbox_tf_4')
export NODE5IP=$(terraform output -json aws_sandbox-Public-IPs | jq -r '.aws_sandbox_tf_5')
export RANCHERPORT=$(ssh -i ../tf_sshkey/id_rsa k8suser@$MASTERIP kubectl get svc rancher -n cattle-system -o=json |jq -r .spec.ports[1].nodePort)
RANCHERWEB=$(echo https://$MASTERIP:$RANCHERPORT)
echo "######################################################"
echo "Rancher web:"
echo $RANCHERWEB
echo ""
echo "below Env are set"
echo "RANCHERWEB, MASTERIP, NODE2IP, NODE3IP, NODE4IP, NODE5IP "
echo "You can SSH to master node by:"
echo "ssh -i ../tf_sshkey/id_rsa k8suser@$MASTERIP"
echo "######################################################"
