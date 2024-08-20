# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'json'

home_dir = File.expand_path(File.dirname(__FILE__))
scripts_dir = home_dir + '/scripts'
conf = home_dir + '/FrontForge.json'

Vagrant.require_version '>= 2.4'

if File.exist? conf then
    settings = JSON::parse(File.read(conf))
else
    abort 'FrontForge settings file not found in #{home_dir}'
end

Vagrant.configure('2') do |config|
  
  #configure the box
  config.vm.box = 'bento/ubuntu-22.04'
  config.vm.box_version = '202212.11.0'
  config.vm.hostname = 'FrontForge'

  #configure the network
  config.vm.network :private_network, ip: settings['vm']['ip']

  #configure a few virtualbox settings
  config.vm.provider 'virtualbox' do |vb|
    vb.name = settings['name'] ||= 'FrontForge'
    vb.customize ['modifyvm', :id, '--memory', settings['vm']['memory'] ||= '2048']
    vb.customize ['modifyvm', :id, '--cpus', settings['vm']['cpus'] ||= '1']
    vb.customize ['modifyvm', :id, '--natdnsproxy1', 'on']
    vb.customize ['modifyvm', :id, '--natdnshostresolver1', settings['natdnshostresolver'] ||= 'on']
    vb.customize ['modifyvm', :id, '--ostype', 'Ubuntu_64']

    if Vagrant::Util::Platform.windows?
      vb.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
    end
  end

  #create an empty ports hash if not in the config file
  # if !settings.has_key?('ports')
  #   settings['ports'] = []
  # end

  #default port forwarding
  # default_ports = {
  #   80 => 8000,
  #   443 => 44300,
  # }

  #add the default ports to the ports hash if they are not there
  # default_ports.each do |guest, host|
  #   unless settings['ports'].any? { |mapping| mapping['guest'] == guest }
  #     settings['ports'].push({
  #       send: host,
  #       to: guest
  #     })
  #   end
  # end

  #configure the forward ports
  if settings.has_key?('ports')
    settings['ports'].each do |port|
      config.vm.network 'forwarded_port', guest: port['to'], host: port['send'], protocol: 'tcp', auto_correct: true
    end
  end

  #configure the shared folders
  if settings.include? 'folders'
    settings['folders'].each do |folder|
      if File.exist? File.expand_path(folder['map'])
        config.vm.synced_folder folder['map'], folder['to']
      else
        config.vm.provision 'shell' do |s|
          s.inline = ">&2 echo \"Unable to mount one of your folders. Please check your folders in FrontForge.json\""
        end
      end
    end
  end

  #provisioning
  config.vm.provision "shell", name: 'Updating: packages', path: scripts_dir + '/initial_startup.sh'
  config.vm.provision "shell", name: 'Installing: nvm, node and npm', path: scripts_dir + '/install_nvm.sh', privileged: false
  
  #install nginx
  config.vm.provision "shell", name: 'Installing: nginx', path: scripts_dir + '/install_nginx.sh', privileged: false

  #install tmux
  #this will be used to start all the sites in dev mode and keep them running
  #without having open multiple shells to ssh into the VM and keep them open
  config.vm.provision "shell", name: 'Installing: tmux', path: scripts_dir + '/install_tmux.sh', privileged: false

  #clear any existing nginx sites
  config.vm.provision 'shell', name: 'Updating: clearing nginx sites', path: scripts_dir + '/clear-nginx.sh'

  #install all the configured nginx sites
  if settings.include? 'sites'

    settings['sites'].each do |site|

      #create ssl certificate
      config.vm.provision 'shell' do |s|
        s.name = 'Creating Certificate: ' + site['map']
        s.path = scripts_dir + '/create-certificate.sh'
        s.args = [site['map']]
      end

      #create the site config
      config.vm.provision 'shell' do |s|
        s.name = 'Creating Site: ' + site['map']
        s.path = scripts_dir + "/create_site_nginx_config.sh"
        s.args = [
            site['map'],
            'http://' + site['proxy']['host'] + ':' + site['proxy']['port'].to_s
        ]
      end

      #start the project in dev mode
      config.vm.provision 'shell' do |s|
        s.name = 'Running Site Dev Mode: ' + site['map']
        s.path = scripts_dir + '/create_tmux_session.sh'
        s.args = [
          site['map'],
          site['to'],
          site['proxy']['host'],
          site['proxy']['port']
        ]
        s.privileged = false
      end
    end
  end

  config.vm.provision 'restart nginx', type: 'shell', inline: 'sudo systemctl restart nginx'
end
