# Overview
Let Siri speak your language with Asiri, the SiriProxy plugin that adds multi language support to Siri. Thanks to Google speech recognition service, Asiri can be configured to speak any language that is supported by Google.

## Installation
Before you install Asiri, make sure you have the following installed:

1. speer ([installation page](https://github.com/alotaiba/speer))
1. ffmpeg ([installation page](http://ffmpeg.org/))
1. SiriProxy duh! [(installation page)](https://github.com/plamoni/SiriProxy)
1. Copy the contents of `config-info.yml` into your `~/.siriproxy/config.yml`
1. Make your modification to the language
1. Issue `rvmsudo siriproxy update` inside your SiriProxy directory
1. Restart SiriProxy

Note: On Ubuntu, you may face some issues during the installation, as there are some dependencies required by curb, which can be installed by the following command:

    sudo apt-get install libcurl4-openssl-dev

## License
Asiri is a project of Abdulrahman Al-Otaiba, the project is dual-licensed under GNU GPLv3, and MIT. See [LICENSE](https://github.com/alotaiba/SiriProxy-Asiri/blob/master/LICENSE) for more details.

## Attribution
I would like to thank the following people, and give them credit for their awesome work, that without them, this project would probably never seen the light:

* Applidium guys - For their awesome work at reverse engineering the Siri proxy, and open sourcing their tools
* Pete (plamoni) - For creating the awesome SiriProxy, which this plugin runs on top of.
* Google - For providing the speech recognition service, though it's undocumented, but I have to give you guys credit for this awesome work.