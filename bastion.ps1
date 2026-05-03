$sgBastion = aws ec2 create-security-group `
  --description "SG del bastion para permitir ssh" `
  --group-name security-group-bastion `
  --query 'GroupId' `
  --output text

#aws ec2 describe-security-groups --group-ids $sgBastion

aws ec2 authorize-security-group-ingress `
  --group-id $sgBastion `
  --protocol tcp `
  --port 22 `
  --cidr 0.0.0.0/0

$AL2023AMI = aws ec2 describe-images `
  --region us-east-1 `
  --owners amazon `
  --filters "Name=name,Values=al2023-ami-*-x86_64" "Name=state,Values=available" `
  --query 'Images[?length(BlockDeviceMappings[?Ebs.VolumeSize>=`8`]) > `0`] | sort_by(@,&CreationDate)[-1].ImageId' `
  --output text

aws ec2 run-instances `
  --region "us-east-1" `
  --image-id $AL2023AMI `
  --instance-type "t3.micro" `
  --security-group-ids $sgBastion `
  --key-name "vockey" `
  --count 1 `
  --associate-public-ip-address `
  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=bastion}]" `
  --iam-instance-profile Name="LabInstanceProfile" `
  --user-data file://user-data.sh