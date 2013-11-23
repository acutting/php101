Vagrant.configure("2") do |config|
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"
  config.vm.box = "precise64"
  config.vm.provision :shell, :path => "vagrant-bootstrap.sh"

  config.vm.network :forwarded_port, guest: 80, host: 8081

  config.vm.provider :virtualbox do |vb|
     vb.customize ["modifyvm", :id, "--memory", "4096"]
  end
end
