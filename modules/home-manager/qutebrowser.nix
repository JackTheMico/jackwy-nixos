{moduleNameSpace, ...}: {pkgs, config, lib,...}:
with lib;
let
  cfg = config.${moduleNameSpace}.qutebrowser;
in {
  options.${moduleNameSpace}.qutebrowser = {
    enable = mkEnableOption "User qutebrowser";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [qutebrowser];
    programs.qutebrowser = {
      enable = true;
      greasemonkey = [
        (pkgs.fetchurl {
          url = "https://update.greasyfork.org/scripts/512931/Dark%20Reader.user.js";
          sha256 = "961508e128fc078075705a4f9d0c709b1ce8f4940e4a41b6353a6cb265b768ce";
        })
        (pkgs.writeText "dark-reader-unofficial.js" ''
          // ==UserScript==
          // @name          Dark Reader (Unofficial)
          // @icon          https://darkreader.org/images/darkreader-icon-256x256.png
          // @namespace     DarkReader
          // @description	  Inverts the brightness of pages to reduce eye strain
          // @version       4.7.15
          // @author        https://github.com/darkreader/darkreader#contributors
          // @homepageURL   https://darkreader.org/ | https://github.com/darkreader/darkreader
          // @run-at        document-end
          // @grant         none
          // @include       http*
          // @require       https://cdn.jsdelivr.net/npm/darkreader/darkreader.min.js
          // @noframes
          // ==/UserScript==
          
          DarkReader.enable({
              brightness: 90,
              contrast: 70,
              sepia: 0
          });
        '')
      ];
    };
  };
}
