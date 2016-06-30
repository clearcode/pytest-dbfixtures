# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "debian/jessie64"

  if Vagrant.has_plugin?('vagrant-cachier')
    # Use the default vagrant-cachier autodetection, with one cache for all instances from the same box.
    config.cache.scope = :box
  end

  # Run provisioning script as the vagrant user, not root. Otherwise we would easily accidentally e.g. create
  # non-vagrant-writeable files in /home/vagrant, while not having root permissions for e.g. apt-get will error during
  # provisioning.
  config.vm.provision 'shell', path: 'bootstrap.sh', privileged: false
end
