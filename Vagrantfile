Vagrant.configure("2") do |config|

  # Enable the Puppet provisioner, with will look in manifests
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "manifests"
    puppet.manifest_file = "default.pp"
    puppet.module_path = "modules"
  end

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "ubuntu/trusty64"

  # Forward guest port 80 to host port 8888 and name mapping
  config.vm.network :forwarded_port, guest: 80, host: 80
  config.vm.network :forwarded_port, guest: 3306, host: 3306

  config.vm.synced_folder "htdocs/", "/vagrant/htdocs/", :owner => "www-data"

  config.vm.provider :virtualbox do |vb|
    vb.name = "iFeel DB-server"
  end

  config.vm.hostname = "iFeel-db"
end