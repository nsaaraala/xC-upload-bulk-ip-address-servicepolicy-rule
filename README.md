# xC-upload-bulk-ip-address-servicepolicy-rule
Terraform Code for Managing IP Blocklists with Volterra
This repository contains Terraform code to create and manage IP blocklists for your Volterra environment using prefix sets. The code automates the following:

Reading IP addresses from a text file (ips.txt).
Chunking the IP addresses into smaller sets (with a maximum of 1024 IPs per chunk).
Creating volterra_ip_prefix_set resources for each chunk of IP addresses.
Creating a volterra_service_policy that includes the prefix sets dynamically in the deny_list section.
Prerequisites
Before you can use this Terraform configuration, you need to have the following:

Terraform installed on your local machine.
A Volterra account with API access and proper authentication credentials.
The ips.txt file containing the IP addresses that you want to block. The file should have one IP address per line (e.g., 192.168.1.1).
Provider Configuration
This Terraform code uses the Volterra provider to interact with the Volterra API. The required provider configuration is as follows:

Steps to Setup the Provider :

Download and store the Volterra certificate from this link : https://docs.cloud.f5.com/docs-v2/administration/how-tos/user-mgmt/Credentials

Obtain the api_p12_file from your Volterra console or administrator.

Store the certificate file securely on your local machine.

Use this to store the password on your local machine " export VES_P12_PASSWORD= sample-password "

Specify the Volterra API URL:

Replace in the URL with your Volterra tenant name.

The URL will be in the format https://tenant-name.console.ves.volterra.io/api.

Usage
1. Clone the Repository
Clone this repository to your local machine:

git clone https://github.com/nsaaraala/xC-block-ip-prefixset-policy.git
cd your-repo-name

2. Add the ips.txt File
Ensure that you have an ips.txt file containing the list of IP addresses that you want to block. This file should be in the same directory as your Terraform configuration.

Example ips.txt:

192.168.1.1
192.168.1.2
192.168.1.3
...

3. Initialize the Terraform Working Directory
Run the following command to initialize the Terraform configuration:


terraform init

4. Apply the Terraform Configuration
Run the following command to apply the Terraform configuration:


terraform apply

Terraform will display a plan of the resources it intends to create. Review the plan and type yes to proceed with the creation of the resources.

5. Verify the Resources
Once the Terraform apply is complete, you can log into your Volterra console to verify that:

IP prefix sets are created with the desired chunks of IP addresses.
Service policy has been created and is configured to use the deny_list with the dynamically generated prefix sets.
