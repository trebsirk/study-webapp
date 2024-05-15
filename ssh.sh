
# get public ip of node
IP=$(terraform output study_instance_public_ip | tr -d '"')
#echo "IP=$IP"
ssh -i "~/.ssh/study" ubuntu@$IP