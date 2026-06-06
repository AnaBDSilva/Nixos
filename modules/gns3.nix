# See also /home/iuricarras/common/optional/gns3.nix
{pkgs, ...}: {
  #Install GNS3 GUI and server
  environment.systemPackages = builtins.attrValues {
    inherit
      (pkgs)
      gns3-gui
      gns3-server
      dynamips
      vpcs
      #ubridge
      wireshark
      qemu_kvm
      docker
      inetutils
      ;
  };

  users.groups.ubridge = {};

  security.wrappers.ubridge = {
    source = "${pkgs.ubridge}/bin/ubridge";
    capabilities = "cap_net_admin,cap_net_raw=ep";
    owner = "root";
    group = "ubridge";
    permissions = "u+rxs,g+rx,o+rx";
  };

  virtualisation.libvirtd.enable = true;    
  virtualisation.docker.enable = true;      
  virtualisation.vmware.host.enable = true;

   environment.etc."GNS3/gns3_server.conf".text = ''
			[Server]
			path = /run/current-system/sw/bin/gns3server
			ubridge_path = /run/wrappers/bin/ubridge
			host = 127.0.0.1
			port = 3080
			images_path = /home/anabs/GNS3/images
			projects_path = /home/anabs/GNS3/projects
			appliances_path = /home/anabs/GNS3/appliances
			additional_images_paths = 
			symbols_path = /home/anabs/GNS3/symbols
			configs_path = /home/anabs/GNS3/configs
			report_errors = True
			auto_start = True
			allow_console_from_anywhere = False
			auth = False
			user = admin
			password = 
			protocol = http
			console_start_port_range = 5000
			console_end_port_range = 10000
			udp_start_port_range = 10000
			udp_end_port_range = 20000

			[Dynamips]
			allocate_aux_console_ports = True
			ghost_ios_support = True
			sparse_memory_support = True
			mmap_support = True
			dynamips_path = /run/current-system/sw/bin/dynamips

			[VMware]
			host_type = ws
			vmnet_start_range = 10
			vmnet_end_range = 30
			block_host_traffic = False
			vmrun_path = /run/current-system/sw/bin/vmrun
		'';
}
