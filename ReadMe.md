A iOS Wrapper to connect with tapatalk api.

Tapatalk API : <https://tapatalk.com/api.php>

**! IMPORTANT** : this project not optimal for using connect with Tapatalk API. You should be use this project like referenced.

## Project Setting


* Build Settings : 
	- Add **-ObjC** to **Other linker Falgs**
	- Add **/usr/include/libxml2** to **Header Search Paths**
* Build Phases : add **libxml2.dylib** to **Link Binary With Libraries**

## Usage

### In AppDelegate.m

* (BOOL)application:(UIApp* lication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
           
            [LNTapatalkSDK startWithFormUrl:@"http://domain.com/forum"];

* (void)applicationDidBecomeActive:(UIApplication *)application

			[LNTapatalkSDK didBecomeActive];

### Get forum

After call [LNTapatalkSDK didBecomeActive] success. You can get forum structer through 
			
			[ModelForum rootForum]
			
### Login

To login and manager logged User, using **LNAccountManager**

### Get Topic

Using **LNForumPaging** for get topics in forum and **LNTopicPaging** for get get posts in topic.

### TapatalkAPI

Read more TatalkAPI.h to see more function connect with tapatalk API.

## License

Copyright (c) 2014 Phuoc Hai <taphuochai@gmail.com>

PHAirViewController is licensed under MIT License Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software