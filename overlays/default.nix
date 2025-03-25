# This file defines overlays
{inputs, ...}: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs final.pkgs;

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });

    # qutebrowser = prev.qutebrowser.overrideAttrs (oldAttrs: {
    #   postFixup =
    #     (oldAttrs.postFixup or "")
    #     + ''
    #       wrapProgram $out/bin/qutebrowser \
    #         --set PYTHONPATH "${final.python312.withPackages (ps: [ps.pynacl])}/lib/python3.12/site-packages"
    #     '';
    # });
  };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      inherit (final) system;
      config.allowUnfree = true;
      overlays = [
        # An example to apply an overlay
        # inputs.nix-yazi-plugins.overlays.default
      ];
    };
  };
}
