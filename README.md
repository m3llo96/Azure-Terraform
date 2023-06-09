
# Terraform Azure Virtual Machine Deployment


This Terraform code allows you to provision a comprehensive set of Azure resources within a specified resource group. The resources include a resource group, virtual network, subnet, network security group, public IP address, network interface, and a Linux virtual machine. By following the instructions below, you will be able to set up your Azure infrastructure easily and efficiently. 🏗️💻🌐


## 📋 Prerequisites

Before you can proceed with the Terraform code, please make sure you have the following prerequisites in place:

-   **Azure Account Credentials**: You will need valid Azure account credentials (e.g., Azure subscription and tenant ID) to authenticate and access Azure resources. 🔑🔒
-   **Terraform Installation**: Ensure that you have Terraform installed on your local machine. You can download the latest version of Terraform from the official website ([https://www.terraform.io/downloads.html](https://www.terraform.io/downloads.html)). 🌍🔧
-   **Azure CLI Installation**: Install the Azure CLI tool on your machine to enable authentication and interact with Azure resources. You can find installation instructions for your specific operating system at ([https://docs.microsoft.com/en-us/cli/azure/install-azure-cli](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)). 🌐⚙️



## 🗒️ Additional Information

### 🔨 Terraform Configuration

The Terraform code provided in  `main.tf`  defines the following Azure resources:

-   **Resource Group**: A logical container for managing Azure resources. The resource group provides an organizational boundary for resources and enables easy management and deletion of related resources.
-   **Virtual Network**: A representation of a network in Azure that allows the resources within it to communicate securely.
-   **Subnet**: A segmented section of a virtual network that isolates resources logically.
-   **Network Security Group**: A virtual firewall that filters and controls network traffic to and from Azure resources.
-   **Public IP Address**: An IP address that can be accessed over the internet.
-   **Network Interface**: A network adapter for the virtual machine, enabling communication with other resources.
-   **Linux Virtual Machine**: A virtual machine running the Ubuntu Server operating system, serving as a scalable and flexible compute resource.


	## 📁 File Structure

	To provide a better understanding of the project's file structure, here is an overview of the files included in this repository:

	- 📁 `.terraform.lock.hcl`: This file contains the version constraints of the provider plugins used in the project.
	- 📁 `customdata.tpl`: A template file that allows you to inject custom data into the virtual machine during provisioning.
	- 🔑 `id_rsa`: The SSH private key file used for Linux VM authentication.
	- 🔑 `id_rsa.pub`: The corresponding SSH public key file for the private key.
	to the Linux virtual machine.
	- 📄 `main.tf`: The main Terraform configuration file that defines the Azure resources to be provisioned.
	- 📄 `terraform.tfstate`: The state file that keeps track of the actual infrastructure state created by Terraform. Do not modify this file manually.
	- 📄 `terraform.tfstate.backup`: A backup of the previous state file.
	- 📄 `terraform.tfvars`: The variable file where you can provide input values for the Terraform variables used in the configuration.
	- 📄 `variables.tf`: The file that defines the input variables used in the Terraform code.
	- 📁 `windows-ssh-script.tpl`: A template file that provides a script for setting up SSH access to Windows virtual machines.
	-  📁 `linux-ssh-script.tpl`: A template file that provides a script for setting up SSH access 


## 📊 Data Queries
In addition to resource provisioning, the Terraform code includes data queries to retrieve information about the created resources. The following data sources are queried:

-   `azurerm_resource_group.RG`: Retrieves information about the resource group.
-   `azurerm_virtual_machine.vm`: Retrieves information about the virtual machine



## 📤 Outputs
The Terraform code provides the following outputs:

-   **resource_group_data**: A map of attributes for the created resource group, including ID, name, location, and tags.
-   **virtual_machine_data**: A map of attributes for the created virtual machine, including ID, identity, private IP address, public IP address, and other relevant information.



## Getting Started

To get started with the deployment, follow these steps:

1. Clone the repository: Clone the repository containing the Terraform configuration files to your local machine.

```
git clone <repository_url>
```

2. Navigate to the project directory: Change your working directory to the project directory.

```
cd <project_directory>
```

3. Authenticate with Azure: Sign in to your Azure account using the Azure CLI.

```
az login
```

4. Initialize the Terraform project: Initialize the Terraform project in the current directory.

```
terraform init
```

5. Modify the configuration: Open the `variables.tf` file and update the variables according to your requirements. You can specify the resource group, virtual network, subnet, VM size, and other parameters.

6. Review the Terraform plan: Generate and review the execution plan to ensure that the desired resources will be provisioned without issues.

```
terraform plan
```

7. Deploy the resources: Apply the Terraform configuration to deploy the Azure VM and associated resources.

```
terraform apply
```

8. Confirm the deployment: After reviewing the execution plan, Terraform will prompt you to confirm the deployment. Type `yes` and press Enter to proceed.

9. Monitor the deployment: Terraform will start provisioning the Azure VM and associated resources. Monitor the progress in the console output.

10. Access the VM: Once the deployment is complete, you can access the VM using the specified username and password or SSH key.



## 🧪 Testing

To ensure the reliability and stability of the Terraform code, it is recommended to perform testing and validation. You can use tools like  `terraform validate`  and  `terraform fmt`  to validate the syntax and format of the code. Additionally, consider setting up automated tests using frameworks like Terratest or implementing integration tests with tools like Azure DevOps pipelines. 🧪✅🔍



## Troubleshooting

### ⚠️Error: "Resource group not found"

**Issue**: When running `terraform apply`, you encounter an error message similar to:
```
Error: Error creating/updating Virtual Machine Scale Set "my-vmss": compute.VirtualMachineScaleSetsClient#CreateOrUpdate: Failure sending request: StatusCode=404 -- Original Error: autorest/azure: Service returned an error. Status=<nil> Code="ResourceGroupNotFound" Message="Resource group 'my-resource-group' could not be found."
```

**Solution**: This error typically occurs when the specified resource group does not exist in your Azure subscription. Ensure that you have created the resource group beforehand or update the `resource_group_name` variable in your Terraform configuration file to an existing resource group.

### ⚠️Error: "Insufficient permissions"

**Issue**: When executing `terraform apply`, you receive an error message like the following:
```
Error: Error creating/updating Virtual Machine Scale Set "my-vmss": compute.VirtualMachineScaleSetsClient#CreateOrUpdate: Failure sending request: StatusCode=403 -- Original Error: autorest/azure: Service returned an error. Status=<nil> Code="AuthorizationFailed" Message="The client 'xyz' with object id 'abc' does not have authorization to perform action 'Microsoft.Compute/virtualMachineScaleSets/write' over scope '/subscriptions/{subscription_id}/resourceGroups/{resource_group_name}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmss_name}'.
```

**Solution**: This error indicates that the user or service principal used for the Terraform deployment does not have sufficient permissions to perform the specified actions. Verify that the account or service principal has the required roles and permissions, such as Contributor or Virtual Machine Contributor, on the target resource group and Azure subscription.



## 📝 Customization

You can customize the Terraform configuration according to your specific requirements. Here are a few examples of possible customizations:

-   Change the Azure region: Update the `location` variable in `variables.tf` to the desired Azure region where you want to provision the resources.
-   Adjust virtual machine settings: Modify the `vm_size`, `os_disk_size_gb`, `admin_username`, and `admin_password` variables in `variables.tf` to define the desired virtual machine size, disk size, and authentication details.
-   Modify networking configuration: Adjust the `vnet_cidr`, `subnet_cidr`, and `public_ip_allocation_method` variables in `variables.tf` to define the IP address ranges and allocation method for the virtual network and subnet.



## 🗑️ Clean Up

To clean up and remove the resources provisioned by Terraform, you can use the following steps:

1.  Run the command `terraform destroy` in your terminal to initiate the resource deletion process. Terraform will provide a summary of the resources that will be destroyed.
    
2.  Review the destruction plan carefully and enter `yes` when prompted to confirm the deletion. This action will remove all the resources created by Terraform.
    
3.  Monitor the deletion process and verify that all resources have been successfully removed from your Azure subscription.



## 🗒️ FAQs (Frequently Asked Questions)

Q: Can I use an existing virtual network instead of creating a new one?
A: Yes, you can modify the Terraform configuration to use an existing virtual network. Update the `network.tf` file to reference the existing virtual network resource instead of creating a new one.

Q: How can I change the operating system of the virtual machine?
A: The operating system is defined in the `vm.tf` file under the `image_reference` variable. You can modify this variable to use a different operating system image available in the Azure Marketplace.

Q: Can I use SSH key authentication instead of a password?
A: Yes, you can modify the Terraform configuration to use SSH key authentication instead of a password. Update the `vm.tf` file to specify the path to your SSH public key file using the `admin_ssh_key` variable.

Q: How can I add additional resources to the Terraform configuration?
A: To add additional resources, such as storage accounts or load balancers, you can create new `.tf` files and define the necessary Terraform configuration. Then, include these files in the main Terraform file (`main.tf`) using the `module` or `resource` block.



## 📚 Additional Resources

To further enhance your understanding of Terraform and Azure infrastructure provisioning, here are some recommended resources:

📖  **Terraform Documentation**: Visit the official Terraform documentation ([https://www.terraform.io/docs/index.html](https://www.terraform.io/docs/index.html)) for comprehensive guides, tutorials, and reference material.  
📖  **Azure Documentation**: Explore the Azure documentation ([https://docs.microsoft.com/en-us/azure/](https://docs.microsoft.com/en-us/azure/)) to learn more about Azure services, best practices, and integration with Terraform.  
📖  **Terraform Registry**: Explore the Terraform Registry ([https://registry.terraform.io/](https://registry.terraform.io/)) for pre-built modules and providers to accelerate your infrastructure deployments.  
📖  **Terraform Community**: Engage with the Terraform community by joining forums, discussion boards, or attending meetups and conferences to learn from others and share your experiences. 🌍📚👥



## 📝 Notes

-   **Azure Permissions**: Ensure that you have the necessary Azure permissions to create the specified resources. Consult with your Azure administrator or refer to the Azure documentation for guidance.
-   **Configuration Customization**: Review the Terraform code and modify it according to your specific requirements before running Terraform commands. Customize resource names, locations, sizes, and other properties as needed.
-   **Review Resource Costs**: Keep in mind that provisioning Azure resources may incur costs. Monitor your Azure usage and billing to avoid any unexpected charges.

## ⚠️ Limitations

It’s important to be aware of the limitations associated with this Terraform configuration. Take note of the following limitation:

-   ⚠️ Limitation: The current configuration only supports the deployment of Linux virtual machines. Support for Windows virtual machines will be added in a future release.



## 🙌 Contributing
Contributions to this project are welcome! If you find any issues or have ideas for improvements, feel free to submit a pull request or open an issue on GitHub. 🤝

