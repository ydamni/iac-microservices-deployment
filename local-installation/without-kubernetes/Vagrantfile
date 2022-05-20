Vagrant.configure("2") do |config|
  
  config.vm.define "node1" do |node1|
    #Node config
    node1.vm.box = "ubuntu/focal64"
    node1.vm.hostname = "node1"
    node1.vm.network "public_network", ip: "192.168.42.1", bridge: "eno1"
    #Provide Memory/CPU
    node1.vm.provider "virtualbox" do |v|
      v.memory = 2048
      v.cpus = 2
    end
    #Implement Ansible
    node1.ssh.insert_key = false
    node1.vm.provision "ansible" do |ansible|
      ansible.verbose = "v"
      #Activate Parallel Execution | Includes hostvars
      ansible.limit = "all"
      ansible.playbook = "playbook.yml"
    end
  end

  config.vm.define "node2" do |node2|
    #Node config
    node2.vm.box = "ubuntu/focal64"
    node2.vm.hostname = "node2"
    node2.vm.network "public_network", ip: "192.168.42.2", bridge: "eno1"
    #Provide Memory/CPU
    node2.vm.provider "virtualbox" do |v|
      v.memory = 2048
      v.cpus = 2
    end
    #Implement Ansible
    node2.ssh.insert_key = false
    node2.vm.provision "ansible" do |ansible|
      ansible.verbose = "v"
      #Activate Parallel Execution | Includes hostvars
      ansible.limit = "all"
      ansible.playbook = "playbook.yml"
    end
  end

end

