# Lab setup

The setup is performed using KVM, Ansible and Terraform to provide an isolated and easily maintainable environment with Satellite on it with a minimal set of configurations.

Self-containing setup for Ansible is granted using an [execution-environment](./execution-environment/) preconfigured with required collections and roles to provision the infrastructure (KVM network/Instance + Satellite setup)

The lab will take care of:

- Provisioning KVM netwok and storage pool
- Provisioning KVM instance for IdM
- Provisioning KVM instances for 2xRHEL9 Clients
- Configure and install IdM following documentation best practices

## Index

- [Requirements](#requirements)
  * [Red Hat Account and Satellite subscription](#red-hat-account-and-rhel-subscription)
  * [Red Hat Enterprise Linux QCOW2 images](#red-hat-enterprise-linux-qcow2-images)
  * [Execution Environment](#execution-environment)
  * [Inventory](#inventory)
  * [Variables](#variables)
  * [Running the setup](#running-the-setup)
  * [Destroying the lab](#destroying-the-lab)


## Requirements

### Red Hat Account and RHEL subscription

A Red Hat Account and valid subscriptions for Red Hat Entrerprise Linux are required. For testing purposes, [Developer Subscription](https://developers.redhat.com/articles/faqs-no-cost-red-hat-enterprise-linux) can be used.

### Red Hat Enterprise Linux QCOW2 images

To provision the KVM instances, a RHEL9 QCOW2 image is needed.

To create the image, the [Red Hat Insights Image Builder](https://console.redhat.com/insights/image-builder) can be used, and instructions to create them are available through the [documentation](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/8/html-single/creating_customized_images_by_using_insights_image_builder/index#assembly_creating-a-customized-rhel-guest-image-using-red-hat-image-builder).

The only relevant setting to flag is *Virtualization - Guest image (.qcow2)* in the **Image Output** settings of the wizard.

No customization is needed, all required configurations will be performed using Ansible.

### Execution Environment

To build the execution environment, we will use [ansible-builder](https://ansible.readthedocs.io/projects/builder/en/latest/) and to run the automation [ansible-navigator](https://ansible.readthedocs.io/projects/navigator/) is needed.

To install them you can run:

```bash
pip3 install ansible-builder ansible-navigator
```

Clone the repository:

```bash
git clone https://github.com/kubealex/redhat-idm-demo
```

To build the execution environment:

```bash
cd lab-setup/execution-environment
ansible-builder build -t idm-demo-ee
```

It will create a container image with all necessary tools to run the automation.

 ### Inventory

The [inventory](./inventory) comes with no predefined hosts. 
The host group **vm_host** represents the machine where KVM is running. A user **with sudo privilege** is required for DNS configuration. Assuming an IP like 1.2.3.4 and a user called **ansible** with password **redhat** the inventory will look like:

```bash
[vm_host]
1.2.3.4 ansible_user=ansible ansible_password=redhat
```

No additional entry is required, but it can be tailored to your needs based on the host configuration (if using SSH keys or other settings).


### Variables

The provisioner comes with almost all predefined values, but a dedicated file called [lab_vars.yml](./lab_vars.yml) is provided to set the following variables:

| Variable                       | Description                                                              | Default Value            |
|--------------------------------|--------------------------------------------------------------------------|--------------------------|
| lab_domain | Dedicated domain for libvirt network, needed for DNS resolution| demo.labs   |
| lab_network | Network CIDR for libvirt network | 192.168.254.0/24|
| rhel9_image_path | Path to the QCOW2 image for RHEL9| |
| rhsm_user | RHSM Username for instance registration | | 
| rhsm_password | RHSM Password for instance registration | | 

| idm_domain | Domain for IdM DNS and LDAP base DN | demo.labs |
| idm_realm | Kerberos realm for IdM | DEMO.LABS | 
| idm_setup_dns | Install and configure DNS (bind) for IdM domain | true | 
| idm_setup_ad_trust | Install and configure packages for AD Trusts | true | 
| idm_setup_dns_forwarders | Configure forwarders for DNS | true |

Variables with no default must be filled.

### Running the setup

To run the setup, after filling the required variables, if your desired user doesn't require a password to use sudo you can run:

```bash
ansible-navigator run --eei idm-demo-ee --pp never -i inventory -m stdout create-lab.yml
```

If your user requires a password to run sudo:

```bash
ansible-navigator run --eei idm-demo-ee --pp never -i inventory -m stdout create-lab.yml -K 
```

You can grab a cup of coffee while it runs, after the setup you will have a working Satellite instance:

| | | 
| - | - | 
| Host | [https://idm.demo.labs](https://idm.demo.labs) |
| Username | admin | 
| Password | admin123 | 

### Destroying the lab

To remove the setup, if your desired user doesn't require a password to use sudo you can run:

```bash
ansible-navigator run --eei idm-demo-ee --pp never -i inventory -m stdout destroy-lab.yml
```

If your user requires a password to run sudo:

```bash
ansible-navigator run --eei idm-demo-ee --pp never -i inventory -m stdout destroy-lab.yml -K 
```
