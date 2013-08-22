## LionSettings is a iOS System settings compatitable framework based on LlamaSettings project


### Introduction
LionSettings based on LlamaSettings code.Add some features like:
  
1)Support use system "Settings.bundles" file in you apps.
  
2)Also support use your own XxxSettings.bundls.
  
3)Auto reload settings after system settings changed.

4)Support  PSTitleValueSpecifier, PSMultiValueSpecifier, PSSliderSpecifier, PSGroupSpecifier.

5)Support extra customized type, to be continue...


## Example

####use Settings.bundle directly.
		
		LionSettingsViewController *lsvc = [[LionSettingsViewController alloc] init] autorelease];
	    //LionSettingsViewController *lsvc = [[LionSettingsViewController alloc] initWithSettingsBundleName:@"Settings" andPlistName:@"Root"] autorelease];

		[self.navigationController pushViewController:lsvc];
		
####use you own MySettings.bundle
		
		LionSettingsViewController *lsvc = [[[LionSettingsViewController alloc] initWithSettingsBundleName:@"CustomSettings"] autorelease];
	    //LionSettingsViewController *lsvc = [[[LionSettingsViewController alloc] initWithSettingsBundleName:@"CustomSettings" andPlistName:@"Root"] autorelease];

		[self.navigationController pushViewController:lsvc];
		

## Special thanks to
[LlamaSettings origin project](https://code.google.com/p/llamasettings/)
Thanks to yorgle http://umlautllama.com/
