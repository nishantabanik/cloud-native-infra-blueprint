MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="==MYBOUNDARY=="

--==MYBOUNDARY==
Content-Type: text/x-shellscript; charset="us-ascii"

#!/bin/bash
set -o xtrace

# Bootstrap the node to join the EKS cluster
/etc/eks/bootstrap.sh ${cluster_name} \
  --b64-cluster-ca ${cluster_auth_base64} \
  --apiserver-endpoint ${endpoint} \
  --container-runtime containerd

# Configure kubelet
echo "net.bridge.bridge-nf-call-iptables=1" >> /etc/sysctl.conf
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p

# Signal completion
/opt/aws/bin/cfn-signal --exit-code $? \
  --stack $${AWS::StackName} \
  --resource NodeGroup \
  --region ${region} || true

--==MYBOUNDARY==--