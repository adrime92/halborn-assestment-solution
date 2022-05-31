Solution
---------

This solution deploys an EKS cluster on AWS. On top of that kubernetes cluster the solution deploys and configure:

- `Nginx`: is a web server that can also be used as a reverse proxy, load balancer, mail proxy and HTTP cache.

- `CloudWatch agent`: is a monitoring and management service that provides data and actionable insights for AWS, hybrid, and on-premises applications and infrastructure resources.

- `Fluent-bit agent`: is an open source and multi-platform Log Processor and Forwarder which allows you to collect data and logs from different sources, unify and send them to multiple destinations. It's fully compatible with Docker and Kubernetes environments.

Requirements
------------

- Python
- Ansible
- Terraform
- AWS account

Tested versions: 
- Python 3.7.3
- ansible 2.9.10
- Terraform v0.14.7

How to use it
------------

(Theoretically) The repository is intended to run automatically either by gitlab-ci. As soon as a new commit is populated to the SCM the pipelines should start deploying the Development environment.

In case you want to run it manually:
1. Clone the repository:
```console
git clone https://github.com/adrime92/halborn-assestment-solution.git
```
2. Install the packages mentioned in the requirement section.
3. Fill the variables in the ```test/group_vars/all/main.yml``` and ```test/group_vars/all/vault.yml```
4. (Optional) Encrypt your ansible vault: 
```console 
ansible-vault encrypt test/group_vars/all/vault.yml
```
5. Run the playbook: 
```console 
ansible-playbook test/test_installation.yml --ask-vault-pass
```

Considerations
------------

During EKS deployment AWS manages the creation of a role which is attached to the EC2 instances that would act as workers. That role is missing one essential policy `CloudWatchAgentServerPolicy`. Without that policy the CloudWatch and Fluent-bit agents won't have permissions to interact with the CloudWatch Service, therefore no metric and log would be sent to AWS CloudWatch. That step has to be done manually once the whole solution is deployed.

Variables
---------
### Terraform Vars

- `region`: AWS region. ***Default*** ```"eu-west-3"```
- `eks_cluster_name`: EKS cluster name. ***Default*** ```"EKS-Dev-env"```
- `vpc_name`: VPC name. ***Default*** ```"EKS-Dev-env"```

Default configuration:
- [EKS *Default*s](./eks-deployment/var.tf)

### Ansible Roles Vars

Default configurations: 

- [Nginx Default](./ansible-role-nginx/Defaults/main.yml)
- [Fluent-bit Default](./ansible-role-fluentBit/Defaults/main.yml)
- [CloudWatch Default](./ansible-role-cloudWatch/Defaults/main.yml)

#### nginx variables
- `nginx_namespace`: Namespace to be created where the nginx workload would be deployed. ***Default*** ```"nginx"```
- `nginx_deployment_name`: Name that the nginx deployment would have on the EKS cluster. ***Default*** ```"nginx-deployment"```
- `nginx_load_balancer_name`: Name of the load balancer to be created on the EKS cluster. ***Default*** ```"nginx-deployment"```
- `nginx_label_app`: Label added to the deployment. ***Default*** ```"nginx"```
- `nginx_replicas`: Number of replicas to be deployed within the deployment. ***Default*** ```2```
- `nginx_image`:  Nginx image to be deployed. ***Default*** ```"adrisan92/adri-nginx:1.0"```
- `nginx_node_port`: Kubernetes nodePort. ***Default*** ```"30001"```
- `nginx_external_port`: Port exposed to the end user. ***Default*** ```"8080"```
- `nginx_container_port`: Port used by the nginx container. ***Default*** ```"80"```
- `nginx_container_port_name`: Name given to the container port. ***Default*** ```"nginx-port"```

#### *Default* vars for Fluent-bit
- `fluentBit_service_account_name`: Username for the service account. ***Default*** ```"fluent-bit"```
- `fluentBit_daemonset_name`: Name given to the daemonset. ***Default*** ```"fluent-bit"```
- `fluentBit_configmap_name`: Name given to the main fluent bit configmap. ***Default*** ```"fluent-bit-config"```
- `fluentBit_namespace`: Namespace to be created where the fluent-bit agent would be deployed. ***Default*** ```"amazon-cloudwatch"```
- `fluentBit_k8s_cluster_name`: EKS cluster name (Needed for fluent-bit agent configuration). ***Default*** ```"EKS-Dev-env"```
- `fluentBit_logs_region`: Region from where logs would be taken. ***Default*** ```"eu-west-3"```

#### *Default* vars for cloudwatch agent
- `cloudWatch_namespace`: Namespace to be created where the fluent-bit agent would be deployed. ***Default*** ```"amazon-cloudwatch"```
- `cloudWatch_service_account_name`: Username for the service account. ***Default*** ```"cloudwatch-agent"```
- `cloudWatch_daemon_set_name`: Name given to the daemonset. ***Default*** ```"cloudwatch-agent"```
- `cloudWatch_configmap_name`: Name given to the main fluent bit configmap. ***Default*** ```"cwagentconfig"```
- `cloudWatch_label_name`: Label added to the deployment. ***Default*** ```"amazon-cloudwatch"```
- `cloudWatch_metrics_collection_interval`: Specifies how often all metrics specified in this configuration file are to be collected. ***Default*** ```60```
- `cloudWatch_force_flush_interval`: Specifies in seconds the maximum amount of time that metrics remain in the memory buffer before being sent to the server. ***Default*** ```5```
- `cloudWatch_k8s_cluster_name`: EKS cluster name (Needed for cloudWatch agent configuration). ***Default*** ```"EKS-Dev-env"```

#### Aditional variables
- `install_prerequisites`: Flag to install or not the prerequisites using the install_prerequisites.yml. ***Default*** ```False```

#### AWS Cli config -- This variables are not needed if ```install_prerequisites``` is set to ```False```
- `aws_region`:  AWS region. ***Default*** ```None```
- `aws_format`:  Output format for AWS cli. ***Default*** ```None```
- `vault_aws_access_key`: AWS access key. ***Default*** ```None```
- `vault_aws_secret_key`: AWS secret key. ***Default*** ```None```

Next steps
-----------
- Use secure protocol HTTPS for the nginx load balancer.
- Automatize the policy attachment to the EC2 Role.
- Implement unitary and integration tests.

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