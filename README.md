# Mate.im

Mate.im是一个寻找共同爱好的线上社区平台。	
使用Phoenix/Elixir，Postgres以及AngularJS开发而成。

#部署说明

## 编译
	
	npm install
	npm install -g brunch
	mix deps.get
	./release.sh

## 配置
###开发环境
1.复制dev.secret.exs.example为dev.secret.exs	
2.修改其中的upyun用来保存上传的图片，具体请参考upyun的form上传方式	
3.修改jwt用来设置jwt_token的混淆字串	
4.配置测试用的数据库地址


###生产环境
1.复制prod.secret.exs.example为prod.secret.exs	
2.修改其中的upyun用来保存上传的图片，具体请参考upyun的form上传方式	
3.修改jwt用来设置jwt_token的混淆字串	
4.配置生产用的数据库地址
## 数据库建表
在所有配置都完成后

开发环境

	mix ecto.migrate

生产环境
	
	MIX_ENV=prod mix ecto.migrate

	
## 运行
开发环境
	
	mix phoenix.server

生产环境	

	./start.sh
