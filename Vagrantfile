# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.

REQUIRED_PLUGINS = %w(vagrant-exec)

plugins_to_install = REQUIRED_PLUGINS.select { |plugin| !Vagrant.has_plugin? plugin }
unless plugins_to_install.empty?
  puts "Installing required plugins: #{plugins_to_install.join(' ')}"
  if system "vagrant plugin install #{plugins_to_install.join(' ')}"
    exec "vagrant #{ARGV.join(' ')}"
  else
    abort "Installation of one or more plugins has failed. Aborting."
  end
end

Vagrant.configure(2) do |config|
  #
  # Basic configuration
  #
  config.vm.box = "opensuse/openSUSE-42.2-x86_64"
  config.vm.hostname = "agile-teamdashboard"
  config.vm.synced_folder ".", "/vagrant", owner: "vagrant", group: 100

  #
  # Vagrant exec plugin
  #
  config.exec.commands '*', directory: '/vagrant'
  config.exec.commands %w(rails rake rspec bundle), env: {'PATH' => './bin:$PATH'}
  config.exec.commands %w[rails rake rspec], prepend: 'bundle exec'

  #
  # Network
  #
  config.vm.network "private_network", type: "dhcp"
  config.vm.network "forwarded_port", guest: 3001, host: 3001

  # Use 1Gb of RAM for Vagrant box (otherwise bundle will go to swap)
  config.vm.provider :virtualbox do |vb|
    vb.customize ['modifyvm', :id, '--memory', 2048]
    vb.customize ['modifyvm', :id, '--cpus', 2]
    vb.destroy_unused_network_interfaces = true
  end

  #
  # Misc
  #
  config.ssh.forward_x11 = true
  config.ssh.forward_agent = true

  #
  # Provisioning
  #
  config.vm.provision :shell, path: "provisioning/bootstrap.sh"
end
