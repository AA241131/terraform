aws ec2 run-instances `
  --region "us-east-1" `
  --image-id "ami-098e39bafa7e7303d" `
  --instance-type "t3.micro" `
  --key-name "vockey" `
  --count 1 `
  --associate-public-ip-address `
  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=bastion}]" `
  --iam-instance-profile Name="LabInstanceProfile" `
  --user-data file://user-data.sh