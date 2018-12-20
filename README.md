## LionSettings

### Introduction
LionSettings is a iOS app settings compatitable framework based on LlamaSettings project which based on LlamaSettings code.Add some features like:
  
1)Support use system "Settings.bundles" file in you apps.
  
2)Also support use your own XxxSettings.bundls.
  
3)Auto reload settings after system settings changed.

4)Support  PSTitleValueSpecifier, PSMultiValueSpecifier, PSSliderSpecifier, PSGroupSpecifier.

5)Support extra customized type, to be continue...


## Component Types

### Compatitable with Official types

PSToggleSwitchSpecifier

PSSliderSpecifier

PSTitleValueSpecifier

PSTextFieldSpecifier

PSMultiValueSpecifier

### Custom types

BLColorPickerSpecifier

BLFullButtonSpecifier

BLURLButtonSpecifier

BLSegmentedSpecifier

BLVolumeSpecifier

PSChildPaneSpecifier

## Example

#### Use Settings.bundle directly.
		
		LionSettingsViewController *lsvc = [[LionSettingsViewController alloc] init] autorelease];
	    //LionSettingsViewController *lsvc = [[LionSettingsViewController alloc] initWithSettingsBundleName:@"Settings" andPlistName:@"Root"] autorelease];

		[self.navigationController pushViewController:lsvc];
		
#### Use you own MySettings.bundle
		
		LionSettingsViewController *lsvc = [[[LionSettingsViewController alloc] initWithSettingsBundleName:@"CustomSettings"] autorelease];
	    //LionSettingsViewController *lsvc = [[[LionSettingsViewController alloc] initWithSettingsBundleName:@"CustomSettings" andPlistName:@"Root"] autorelease];

		[self.navigationController pushViewController:lsvc];
		

## Origin reference:

[LlamaSettings origin project](https://code.google.com/p/llamasettings/)
Thanks to yorgle http://umlautllama.com/

