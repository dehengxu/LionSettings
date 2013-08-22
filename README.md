###LionSettings is a iOS System settings compatitable framework based on LlamaSettings project


####Introduction
LionSettings based on LlamaSettings code.Add some features like:
  
1)Support system "Settings.bundles" file.
  
2)Also support your own XxxSettings.bundls.
  
3)Auto reload settings after system settings changed.

4)Support  PSTitleValueSpecifier, PSMultiValueSpecifier, PSSliderSpecifier, PSGroupSpecifier.

5)Support extra customized type, to be continue...
  
####Example using compatibel with Settings.bundle
		LionSettingsViewController *lsvc = [[LionSettingsViewController alloc] init] autorelease];
	    //LionSettingsViewController *lsvc = [[LionSettingsViewController alloc] initWithSettingsBundleName:@"Settings" andPlistName:@"Root"] autorelease];

		[self.navigationController pushViewController:lsvc];
		
####Example using you own MySettings.bundle
		LionSettingsViewController *lsvc = [[[LionSettingsViewController alloc] initWithSettingsBundleName:@"CustomSettings"] autorelease];
	    //LionSettingsViewController *lsvc = [[[LionSettingsViewController alloc] initWithSettingsBundleName:@"CustomSettings" andPlistName:@"Root"] autorelease];

		[self.navigationController pushViewController:lsvc];
		

##### Special thanks to
[LlamaSettings origin project](https://code.google.com/p/llamasettings/)
Thanks to yorgle http://umlautllama.com/
