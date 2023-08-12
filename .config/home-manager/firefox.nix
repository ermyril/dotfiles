{ lib, config, pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-wayland;
    profiles = {
      ${config.home.username} = {
        extensions = 
          with pkgs.nur.repos.rycee.firefox-addons; [
            #https-everywhere
            privacy-badger
            firefox-translations
            vimium
            #adnauseam
            bitwarden
            consent-o-matic
        ];
        search = {
          force = true;
          default = "DuckDuckGo";
          order = [ "DuckDuckGo" "Google" ];
          engines = {
            "Amazon.ca".metaData.alias = "@a";
            "Bing".metaData.hidden = true;
            "eBay".metaData.hidden = true;
            "Google".metaData.alias = "@g";
            "Wikipedia (en)".metaData.alias = "@w";

            "GitHub" = {
              urls = [{
                template = "https://github.com/search";
                params = [
                  { name = "q"; value = "{searchTerms}"; }
                ];
              }];
              icon = "${pkgs.fetchurl {
                url = "https://github.githubassets.com/favicons/favicon.svg";
                sha256 = "sha256-apV3zU9/prdb3hAlr4W5ROndE4g3O1XMum6fgKwurmA=";
              }}";
              definedAliases = [ "@gh" ];
            };

            "Nix Packages" = {
              urls = [{
                template = "https://search.nixos.org/packages";
                params = [
                  { name = "channel"; value = "unstable"; }
                  { name = "query"; value = "{searchTerms}"; }
                ];
              }];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@np" ];
            };

            "NixOS Wiki" = {
              urls = [{
                template = "https://nixos.wiki/index.php";
                params = [ { name = "search"; value = "{searchTerms}"; }];
              }];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@nw" ];
            };

            "Nixpkgs Issues" = {
              urls = [{
                template = "https://github.com/NixOS/nixpkgs/issues";
                params = [
                  { name = "q"; value = "{searchTerms}"; }
                ];
              }];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@ni" ];
            };

            # A good way to find genuine discussion
            "Reddit" = {
              urls = [{
                template = "https://www.reddit.com/search";
                params = [
                  { name = "q"; value = "{searchTerms}"; }
                ];
              }];
              icon = "${pkgs.fetchurl {
                url = "https://www.redditstatic.com/accountmanager/favicon/favicon-512x512.png";
                sha256 = "sha256-WiXqffmuCVCOJ/rpqyhFK59bz1lKnUOp9/aoEAYRsn0=";
              }}";
              definedAliases = [ "@r" ];
            };

            "Youtube" = {
              urls = [{
                template = "https://www.youtube.com/results";
                params = [ { name = "search_query"; value = "{searchTerms}"; }];
              }];
              icon = "${pkgs.fetchurl {
                url = "www.youtube.com/s/desktop/8498231a/img/favicon_144x144.png";
                sha256 = "sha256-lQ5gbLyoWCH7cgoYcy+WlFDjHGbxwB8Xz0G7AZnr9vI=";
              }}";
              definedAliases = [ "@y" ];
            };
          };
        };

        settings = {
          "accessibility.typeaheadfind.flashBar" = 0;
          "app.shield.optoutstudies.enabled" = false;
          "apz.overscroll.enabled" = true;
          "browser.aboutConfig.showWarning" = false;
          "browser.aboutwelcome.enabled" = false;
          "browser.contentblocking.category" = "strict";
          "browser.discovery.enabled" = false;
          "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
          "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
          "browser.newtabpage.activity-stream.feeds.section.highlights" = false;
          "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
          "browser.newtabpage.activity-stream.feeds.snippets" = false;
          "browser.newtabpage.activity-stream.feeds.telemetry" = false;
          "browser.newtabpage.activity-stream.feeds.topsites" = true;
          "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts.havePinned" = "google"; # Don't autopin google on first run
          "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          "browser.newtabpage.activity-stream.telemetry" = false;
          "browser.newtabpage.blocked" = builtins.toJSON {
            # Dismiss builtin shortcuts
            "26UbzFJ7qT9/4DhodHKA1Q==" = 1;
            "4gPpjkxgZzXPVtuEoAL9Ig==" = 1;
            "eV8/WsSLxHadrTL1gAxhug==" = 1;
            "gLv0ja2RYVgxKdp0I5qwvA==" = 1;
            "oYry01JR5qiqP3ru9Hdmtg==" = 1;
            "T9nJot5PurhJSy8n038xGA==" = 1;
          };
          "browser.newtabpage.enabled" = true;
          "browser.newtabpage.pinned" = builtins.toJSON [ ];
          "browser.places.importBookmarksHTML" = true;
          "browser.safebrowsing.malware.enabled" = false;
          "browser.safebrowsing.phishing.enabled" = false;
          "browser.search.suggest.enabled" = false;
          "browser.search.update" = false;
          "browser.shell.checkDefaultBrowser" = false;
          "browser.startup.homepage" = "about:home";
          "browser.startup.page" = 3; # Restore previous session
          "browser.tabs.warnOnClose" = false;
          "browser.toolbars.bookmarks.visibility" = "newtab";
          "browser.uiCustomization.state" = builtins.toJSON {
            placements = {
              widget-overflow-fixed-list = [ ];
              nav-bar = [
                "back-button"
                "forward-button"
                "stop-reload-button"
                "urlbar-container"
                "downloads-button"
                "fxa-toolbar-menu-button"
                # Extensions
                "_d7742d87-e61d-4b78-b8a1-b469842139fa_-browser-action" # Vimium
                "_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action"
                #""
              ];
              toolbar-menubar = [ "menubar-items" ];
              TabsToolbar = [
                "tabbrowser-tabs"
                "new-tab-button"
                "alltabs-button"
              ];
              PersonalToolbar = [
                "import-button"
                "personal-bookmarks"
              ];
            };
            seen = [
              "save-to-pocket-button"
              "developer-button"

              # Extensions
              "_d7742d87-e61d-4b78-b8a1-b469842139fa_-browser-action" # Vimium
              "_testpilot-containers-browser-action"
              "ghosttext_bfred_it-browser-action"
              "jid1-zadieub7xozojw_jetpack-browser-action" # Media Keys
              "languagetool-webextension_languagetool_org-browser-action"
            ];
            dirtyAreaCache = [
              "nav-bar"
              "toolbar-menubar"
              "TabsToolbar"
              "PersonalToolbar"
            ];
            currentVersion = 17;
            newElementCount = 2;
          };
          "browser.warnOnQuit" = false;
          "datareporting.healthreport.uploadEnabled" = false;
          "datareporting.policy.dataSubmissionEnabled" = false;
          "devtools.selfxss.count" = 5; # Allow pasting into console
          "dom.security.https_only_mode" = true;
          "extensions.activeThemeID" = "firefox-alpenglow@mozilla.org";
          "extensions.formautofill.creditCards.available" = false;
          "extensions.formautofill.creditCards.enabled" = false;
          "layout.spellcheckDefault" = 1;
          "media.eme.enabled" = true;
          "services.sync.engine.creditcards" = false;
          "services.sync.engine.passwords" = false;
          "services.sync.engine.prefs" = false;
          "services.sync.username" = "ermyril@gmail.com";
          "signon.rememberSignons" = false; # Use keepassxc instead
          "toolkit.telemetry.pioneer-new-studies-available" = false;
        };
      };
    };
  };

  xdg = {
    desktopEntries = {
      # Overrides upstream desktop entry to open firefox in a new tab
      firefox = {
        categories = [ "Network" "WebBrowser" ];
        exec = "firefox --new-tab %U";
        genericName = "Web Browser";
        icon = "firefox";
        mimeType = [
          "application/vnd.mozilla.xul+xml"
          "application/xhtml+xml"
          "text/html"
          "text/xml"
          "x-scheme-handler/ftp"
          "x-scheme-handler/http"
          "x-scheme-handler/https"
        ];
        name = "Firefox";
        type = "Application";
      };
    };

    mimeApps.defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
    };
  };

  home.sessionVariables = {
    # Touchscreen support
    MOZ_USE_XINPUT2 = "1";
  };
}
