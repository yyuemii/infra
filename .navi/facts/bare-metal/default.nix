let
  raw = builtins.fromJSON (builtins.readFile ./outputs.json);
in
builtins.mapAttrs (n: v: v.value) raw
