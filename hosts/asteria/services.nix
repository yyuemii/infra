{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../common/k3s
    ../common/tailscale
  ];

  services.lumi.k3s = {
    enable = true;

    fluxcd = {
      enable = true;

      repository = "https://github.com/yyuemii/infra";
      path = "services";
    };

    oidc = {
      enable = true;

      issuer = "https://id.yyuemii.co";
      roles = {
        developer = "cluster-admin";
      };
    };
  };

  services.lumi.tailscale = {
    enable = true;

    routes = [
      # advertise dns server and server ip addr for routing of lu.mi
      "${lib.elemAt config.networking.nameservers 0}/32"
      "${(lib.elemAt config.networking.interfaces.enp0s31f6.ipv4.addresses 0).address}/32"
    ];
  };

  systemd.services.disable-eee = {
    description = "Disable energy efficient ethernet to fix link up issues after network loss";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.ethtool}/bin/ethtool --set-eee enp0s31f6 eee off";
    };
  };

  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;

    servers.lockout = {
      enable = true;
      package = pkgs.fabricServers.fabric-1_21_11.override { loaderVersion = "0.19.2"; };

      operators = {
        bwia = "8bb3bef1-e063-4faa-8712-4c2335704fc5";
        tea6 = "e54e956e-4a7a-4336-b6fd-861b75f740c8";
      };

      whitelist = {
        bwia = "8bb3bef1-e063-4faa-8712-4c2335704fc5";
        tea6 = "e54e956e-4a7a-4336-b6fd-861b75f740c8";
      };

      serverProperties = {
        motd = "draftout";
        white-list = true;
      };

      symlinks = {
        mods = pkgs.linkFarmFromDrvs "mods" (
          builtins.attrValues {
            Fabric-API = pkgs.fetchurl {
              url = "https://mediafilez.forgecdn.net/files/8073/350/fabric-api-0.141.4%2B1.21.11.jar";
              sha512 = "c092d48c6453bec3264f80f6a35bb334aba3112b5cd6c0e0b2676ce4d81e702cb1e522337f3a732348e757cc2226da3c601a314ae8766334f16af71a13bcc98d";
            };
            Lockout = pkgs.fetchurl {
              url = "https://github.com/Specnr/lockout-fabric/releases/download/v0.12.2/lockout-fabric-0.12.2.jar";
              sha512 = "5adb0605af728a35d69541fd3cf6a278ca7288c5cf4060c960f58d7e2aa96f8bf888c25e6b6cc46f2009a5febbaa63ec5fda84e851ab615c51e4f8e423875617";
            };
          }
        );
      };
    };
  };
}
