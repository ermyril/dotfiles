{ pkgs, config, ... }:
{

  boot.kernelParams = [ "fbcon=rotate:1" ];
	# boot.kernelPatches = [ {
	# 	name = "vbtn-test";
	# 	patch = ./vbtn.patch;
	# 	extraConfig = ''
	# 			CRASH_DUMP y
	# 			DEBUG_INFO y
	# 		'';
	# } ];

	hardware.sensor.iio.enable = true;

  environment.systemPackages = with pkgs; [
		libinput
		iio-sensor-proxy
		lm_sensors
		auto-cpufreq
		i2c-tools
		#gnomeExtensions.screen-rotate
  ];

	#services.auto-cpufreq.enable = true;

#	services.udev.extraHwdb = " 
#sensor:modalias:acpi:MXC6655:MXC6655:dmi:*:svnCHUWIInnovationAndTechnology*:pnMiniBookX:*
# ACCEL_MOUNT_MATRIX=0, 1, 0; -1, 0, 0; 0, 0, 1
#	";
	#boot.kernelModules = [ "mxc4005" ];
	security.tpm2 = {
		enable = true;
		pkcs11.enable = true; # expose /run/current-system/sw/lib/libtpm2_pkcs11.so
		tctiEnvironment.enable = true; # TPM2* env variabls
	};

	environment.etc = {
    machine-info = {
      text = ''
        CHASSIS=convertible
      '';
      mode = "0440";
    };
  };


	users.users.ermyril.extraGroups = [ "tss" ]; # tss group has access to TPM devices

  boot.loader.systemd-boot.consoleMode = "0";
  systemd.tmpfiles.rules = [
    "L+ /run/gdm/.config/monitors.xml - - - - ${pkgs.writeText "gdm-monitors.xml" ''
      <!-- this should all be copied from your ~/.config/monitors.xml -->
	<monitors version="2">
	  <configuration>
	    <logicalmonitor>
	      <x>0</x>
	      <y>0</y>
	      <scale>1</scale>
	      <primary>yes</primary>
	      <transform>
		<rotation>right</rotation>
		<flipped>no</flipped>
	      </transform>
	      <monitor>
		<monitorspec>
		  <connector>DSI-1</connector>
		  <vendor>unknown</vendor>
		  <product>unknown</product>
		  <serial>unknown</serial>
		</monitorspec>
		<mode>
		  <width>1200</width>
		  <height>1920</height>
		  <rate>50.002</rate>
		</mode>
	      </monitor>
	    </logicalmonitor>
	  </configuration>
	</monitors>
    ''}"
  ];
}
