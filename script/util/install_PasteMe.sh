#!/bin/bash

# PasteMe 是一个无需注册的文本分享平台，针对代码提供了额外的高亮功能。
# project: https://github.com/LucienShui/PasteMe
# document: https://docs.pasteme.cn
# ref: https://isedu.top/index.php/archives/24/

InstallPasteMe(){
	cd ~
	mkdir PasteMe
	cd ~/PasteMe/
	wget https://cdn.jsdelivr.net/gh/LucienShui/PasteMe@main/docker-compose.yml
	docker-compose up -d

}

UpdatePasteMe(){
	docker-compose pull
	docker-compose up -d
}