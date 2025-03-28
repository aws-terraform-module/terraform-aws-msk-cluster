variable "cluster_name" {
  description = "Name of the MSK cluster."
  type        = string
}

variable "kafka_version" {
  description = "Specify the desired Kafka software version."
  type        = string
}

variable "number_of_nodes" {
  description = "The desired total number of broker nodes in the kafka cluster. It must be a multiple of the number of specified client subnets."
  type        = number
}

variable "client_subnets" {
  description = "A list of subnets to connect to in client VPC"
  type        = list(string)
}

variable "volume_size" {
  description = "The size in GiB of the EBS volume for the data drive on each broker node."
  type        = number
  default     = 1000
}

variable "instance_type" {
  description = "Specify the instance type to use for the kafka brokers. e.g. kafka.m5.large."
  type        = string
}

variable "extra_security_groups" {
  description = "A list of extra security groups to associate with the elastic network interfaces to control who can communicate with the cluster."
  type        = list(string)
  default     = []
}

variable "enhanced_monitoring" {
  description = "Specify the desired enhanced MSK CloudWatch monitoring level to one of three monitoring levels: DEFAULT, PER_BROKER, PER_TOPIC_PER_BROKER or PER_TOPIC_PER_PARTITION. See [Monitoring Amazon MSK with Amazon CloudWatch](https://docs.aws.amazon.com/msk/latest/developerguide/monitoring.html)."
  type        = string
  default     = "DEFAULT"
}

variable "prometheus_jmx_exporter" {
  description = "Indicates whether you want to enable or disable the JMX Exporter."
  type        = bool
  default     = false
}

variable "prometheus_node_exporter" {
  description = "Indicates whether you want to enable or disable the Node Exporter."
  type        = bool
  default     = false
}

variable "server_properties" {
  description = "A map of the contents of the server.properties file. Supported properties are documented in the [MSK Developer Guide](https://docs.aws.amazon.com/msk/latest/developerguide/msk-configuration-properties.html)."
  type        = map(string)
  default     = {}
}

variable "encryption_at_rest_kms_key_arn" {
  description = "You may specify a KMS key short ID or ARN (it will always output an ARN) to use for encrypting your data at rest. If no key is specified, an AWS managed KMS ('aws/msk' managed service) key will be used for encrypting the data at rest."
  type        = string
  default     = ""
}

variable "encryption_in_transit_client_broker" {
  description = "Encryption setting for data in transit between clients and brokers. Valid values: TLS, TLS_PLAINTEXT, and PLAINTEXT. Default value is TLS_PLAINTEXT."
  type        = string
  default     = "TLS_PLAINTEXT"
}

variable "encryption_in_transit_in_cluster" {
  description = "Whether data communication among broker nodes is encrypted. Default value: true."
  type        = bool
  default     = true
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "s3_logs_bucket" {
  description = "Name of the S3 bucket to deliver logs to."
  type        = string
  default     = ""
}

variable "s3_logs_prefix" {
  description = "Prefix to append to the folder name."
  type        = string
  default     = ""
}

variable "cloudwatch_logs_group" {
  description = "Name of the Cloudwatch Log Group to deliver logs to."
  type        = string
  default     = ""
}

variable "firehose_logs_delivery_stream" {
  description = "Name of the Kinesis Data Firehose delivery stream to deliver logs to."
  type        = string
  default     = ""
}

variable "client_authentication_unauthenticated_enabled" {
  description = "Enables unauthenticated access."
  type        = bool
  default     = false
}

variable "client_authentication_sasl_iam_enabled" {
  description = "Enables IAM client authentication."
  type        = bool
  default     = false
}

variable "client_authentication_sasl_scram_secrets_arns" {
  description = "Associates SCRAM secrets stored in the Secrets Manager. You need [secret policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/msk_scram_secret_association)."
  type        = list(string)
  default     = []
}

variable "client_authentication_tls_certificate_authority_arns" {
  description = "List of ACM Certificate Authority Amazon Resource Names (ARNs)."
  type        = list(string)
  default     = []
}

variable "provisioned_volume_throughput" {
  description = "Throughput value of the EBS volumes for the data drive on each kafka broker node in MiB per second. The minimum value is 250. The maximum value varies between broker type. See [https://docs.aws.amazon.com/msk/latest/developerguide/msk-provision-throughput.html#throughput-bottlenecks](documentation on throughput bottlenecks)."
  type        = number
  default     = null
}


variable "create_security_group" {
  type    = bool
  default = false
}

variable "security_group_name" {
  type    = string
  default = "MSK security group name."
}

variable "security_group_description" {
  type    = string
  default = "MSK security group description."
}
variable "ingress_with_cidr_blocks" {
  type        = list(map(string))
  default     = []
  description = <<-EOT
    List of ingress rules to create with CIDR blocks as source.
    Each rule object requires these attributes:
      - description: Description of the rule
      - from_port: Start port range
      - to_port: End port range  
      - protocol: Protocol (tcp, udp, icmp, or all)
      - cidr_blocks: List of IPv4 CIDR blocks
    
    Optional attributes:
      - ipv6_cidr_blocks: List of IPv6 CIDR blocks
    
    Note: When 'create_security_group = true', these rules will be applied to the
    created security group, and the 'extra_security_groups' parameter will be ignored.
    
    Example:
    ```
    ingress_with_cidr_blocks = [
      {
        description = "HTTPS from anywhere"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
    ```
    EOT
}
