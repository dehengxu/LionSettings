###LionSettings is a iOS System settings compatitable framework based on LlamaSettings project


####Introduction
LionSettings based on LlamaSettings code.Add some features like:
  
  *)Support system "Settings.bundles" file.
  
  *)Also support your own settings.bundls.
  
  *)Auto reload settings after system settings changed.
  
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
