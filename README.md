Solution
---------

This solution deploys an EKS cluster on AWS. On top of that kubernetes cluster the solution deploys and configure:

- `Nginx`: is a web server that can also be used as a reverse proxy, load balancer, mail proxy and HTTP cache.

- `CloudWatch agent`: is a monitoring and management service that provides data and actionable insights for AWS, hybrid, and on-premises applications and infrastructure resources.

- `Fluent-bit agent`: is an open source and multi-platform Log Processor and Forwarder which allows you to collect data and logs from different sources, unify and send them to multiple destinations. It's fully compatible with Docker and Kubernetes environments.

Requirements
------------

- AWS account

Considerations
------------

During EKS deployment AWS manage the creation of a role which is attached to the EC2 instances that would act as workers. That role is missing one essential policy `CloudWatchAgentServerPolicy`. Without that policy the CloudWatch and Fluent-bit agents won't have permissions to interact with the CloudWatch Service, therefore no metric and log would be sent to AWS CloudWatch. That step has to be done manually once the whole solution is deployed.

Variables
---------
## Terraform Vars

- `region`: AWS region. Default "eu-west-3"
- `eks_cluster_name`: EKS cluster name. Default "EKS-Dev-env"
- `vpc_name`: VPC name. Default "

Default values in:
- [EKS Defaults](./eks-deployment/var.tf)

## Ansible Roles Vars

For inspiring yourselves of the configuration of each component of the solution check the default values: 

- [Nginx Defaults](./ansible-role-nginx/defaults/main.yml)
- [Fluent-bit Defaults](./ansible-role-fluentBit/defaults/main.yml)
- [CloudWatch Defaults](./ansible-role-cloudWatch/defaults/main.yml)

### nginx variables
- `namespace`: Namespace to be created where the nginx workload would be deployed. Default "nginx"
- `deployment_name`: Name that the nginx deployment would have on the EKS cluster.Default "nginx-deployment"
- `load_balancer_name`: Name of the load balancer to be created on the EKS cluster.Default "nginx-deployment"
- `label_app`: Label added to the deployment. Default "nginx"
- `replicas`: Number of replicas to be deployed within the deployment. Default 2
- `image`:  Nginx image to be deployed. Default "adrisan92/adri-nginx:1.0"
- `node_port`: Kubernetes nodePort. Default "30001"
- `external_port`: Port exposed to the end user. Default "8080"
- `container_port`: Port used by the nginx container. Default "80"
- `container_port_name`: Name given to the container port. Default "nginx-port"

### Default vars for Fluent-bit
- `service_account_name`: Username for the service account. Default "fluent-bit"
- `daemonset_name`: Name given to the daemonset. Default "fluent-bit"
- `configmap_name`: Name given to the main fluent bit configmap. Default "fluent-bit-config"
- `namespace`: Namespace to be created where the fluent-bit agent would be deployed. Default "amazon-cloudwatch"
- `k8s_cluster_name`: EKS cluster name (Needed for fluent-bit agent configuration).Default "EKS-Dev-env"
- `logs_region`: Region from where logs would be taken. Default "eu-west-3"

### Default vars for cloudwatch agent
- `namespace`: Namespace to be created where the fluent-bit agent would be deployed. Default "amazon-cloudwatch"
- `service_account_name`: Username for the service account. Default "cloudwatch-agent"
- `daemon_set_name`: Name given to the daemonset. Default "cloudwatch-agent"
- `configmap_name`: Name given to the main fluent bit configmap. Default "cwagentconfig"
- `label_name`: Label added to the deployment. Default "amazon-cloudwatch"
- `metrics_collection_interval`: Specifies how often all metrics specified in this configuration file are to be collected Default 60
- `force_flush_interval`: Specifies in seconds the maximum amount of time that metrics remain in the memory buffer before being sent to the server. Default 5
- `k8s_cluster_name`: EKS cluster name (Needed for cloudWatch agent configuration).Default "EKS-Dev-env"

### Global vars
- `aws_region`:  AWS region. Default None
- `aws_format`:  Output format for AWS cli. Default None

Improvements
-----------
- Use secure protocol HTTPS for the nginx load balancer.
- Automatize the policy attachment to the EC2 Role.


Sources
---------

- EKS: 
    - https://aws.amazon.com/eks/
    - https://www.eksworkshop.com/010_introduction/eks/

- CloudWatch  and Fluent-bit:
    - https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Container-Insights-prerequisites.html
    - https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Container-Insights-setup-metrics.html
    - https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Container-Insights-setup-logs-FluentBit.html

- https://stackoverflow.com/