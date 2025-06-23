{
  inputs,
  nixosConfiguration,
  ...
}:
nixosConfiguration.extendModules {
  modules = [
    (
      {pkgs, ...}: {
        virtualisation.vmVariant = {
          virtualisation.forwardPorts = [
            {
              from = "host";
              host.port = 2222;
              guest.port = 22;
            }
          ];
          imports = [
            inputs.nixos-hardware.nixosModules.common-gpu-amd
            # hydenix-inputs.nixos-hardware.nixosModules.common-cpu-intel
          ];
          virtualisation = {
            memorySize = 8192;
            cores = 6;
            diskSize = 20480;
            qemu = {
              options = [
                "-device virtio-vga-gl"
                "-display gtk,gl=on,grab-on-hover=on"
                "-usb -device usb-tablet"
                "-cpu host"
                "-enable-kvm"
                "-machine q35,accel=kvm"
                "-device intel-iommu"
                "-device ich9-intel-hda"
                "-device hda-output"
                "-vga none"
              ];
            };
          };
          #! you can set this to skip login for sddm
          # services.displayManager.autoLogin = {
          #   enable = true;
          #   user = "jr";
          # };
          services.xserver = {
            videoDrivers = [
              "virtio"
            ];
          };

          system.stateVersion = "25.05";
        };

        # Enable SSH server
        services.openssh = {
          enable = true;
          settings = {
            PermitRootLogin = "no";
            PasswordAuthentication = true;
          };
        };

        virtualisation.libvirtd.enable = true;
        environment.systemPackages = with pkgs; [
          open-vm-tools
          spice-gtk
          spice-vdagent
          spice
        ];
        services.qemuGuest.enable = true;
        services.spice-vdagentd = {
          enable = true;
        };
        hardware.graphics.enable = true;

        # Enable verbose logging for home-manager
        # home-manager.verbose = true;
      }
    )
  ];
}
