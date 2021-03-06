## master(s)

data "template_file" "master_config" {
  template = "${file("${path.module}/configs/gerrit-azure.yml")}"

  vars {
    config_url = "${var.config_url}"
    master_nb = "${var.master_nb}"
    master_ips = "${element(concat(azurerm_network_interface.master_nic.*.private_ip_address), 0)}"
    gerrit_hostname = "${var.gerrit_hostname}"
    gerrit_ui = "${var.gerrit_ui}"
    gerrit_auth_type = "${var.gerrit_auth_type}"
    gerrit_oauth_github_client_id = "${var.gerrit_oauth_github_client_id}"
    gerrit_oauth_github_client_secret = "${var.gerrit_oauth_github_client_secret}"
    gerrit_oauth_office365_client_id = "${var.gerrit_oauth_office365_client_id}"
    gerrit_oauth_office365_client_secret = "${var.gerrit_oauth_office365_client_secret}"
    gerrit_oauth_google_client_id = "${var.gerrit_oauth_google_client_id}"
    gerrit_oauth_google_client_secret = "${var.gerrit_oauth_google_client_secret}"
    gerrit_oauth_bitbucket_client_id = "${var.gerrit_oauth_bitbucket_client_id}"
    gerrit_oauth_bitbucket_client_secret = "${var.gerrit_oauth_bitbucket_client_secret}"
    gerrit_oauth_gitlab_client_id = "${var.gerrit_oauth_gitlab_client_id}"
    gerrit_oauth_gitlab_client_secret = "${var.gerrit_oauth_gitlab_client_secret}"
    gerrit_oauth_airvantage_client_id = "${var.gerrit_oauth_airvantage_client_id}"
    gerrit_oauth_airvantage_client_secret = "${var.gerrit_oauth_airvantage_client_secret}"
  }
}

resource "azurerm_network_interface" "master_nic" {
  count               = "${var.master_nb}"
  name                = "${var.env_prefix}master${count.index}-nic"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group}"

  ip_configuration {
    name                          = "${var.env_prefix}master${count.index}-ipconfig"
    subnet_id                     = "${var.subnet_id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = "${var.load_balancer ? "" : (var.is_public ? azurerm_public_ip.public_ip.id : "")}"
    load_balancer_backend_address_pools_ids = [
      "${coalescelist(azurerm_lb_backend_address_pool.lb_public_backend.*.id,
                      azurerm_lb_backend_address_pool.lb_private_backend.*.id)}",
    ]
  }
}

resource "azurerm_managed_disk" "master_data" {
  count                = "${var.master_nb}"
  name                 = "${var.env_prefix}master${count.index}-data"
  location             = "${var.location}"
  resource_group_name  = "${var.resource_group}"
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = "${var.data_disk_size_gb}"
}

resource "azurerm_availability_set" "master_availability_set" {
  name                 = "${var.env_prefix}master-availabilityset"
  location             = "${var.location}"
  resource_group_name  = "${var.resource_group}"
  managed              = "true"
  platform_update_domain_count = "${var.platform_update_domain_count}"
  platform_fault_domain_count  = "${var.platform_fault_domain_count}"
}

resource "azurerm_virtual_machine" "master" {
  count                 = "${var.master_nb}"
  name                  = "${var.env_prefix}master${count.index}"
  location              = "${var.location}"
  resource_group_name   = "${var.resource_group}"
  vm_size               = "${var.master_vm_size}"
  network_interface_ids = ["${azurerm_network_interface.master_nic.*.id[count.index]}"]
  availability_set_id   = "${azurerm_availability_set.master_availability_set.id}"
  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "${var.image_publisher}"
    offer     = "${var.image_offer}"
    sku       = "${var.image_sku}"
    version   = "${var.image_version}"
  }

  storage_os_disk {
    name              = "${var.env_prefix}master${count.index}-osdisk"
    managed_disk_type = "Standard_LRS"
    caching           = "ReadWrite"
    create_option     = "FromImage"
  }

  storage_data_disk {
    name            = "${azurerm_managed_disk.master_data.*.name[count.index]}"
    managed_disk_id = "${azurerm_managed_disk.master_data.*.id[count.index]}"
    create_option   = "Attach"
    lun             = 0
    disk_size_gb    = "${azurerm_managed_disk.master_data.*.disk_size_gb[count.index]}"
  }

  os_profile {
    computer_name  = "${var.env_prefix}master${count.index}"
    admin_username = "${var.admin_username}"
    custom_data    = "${data.template_file.master_config.rendered}"
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path = "/home/${var.admin_username}/.ssh/authorized_keys"
      key_data = "${var.admin_ssh_key}"
    }
  }
}

