自用项目，简单记录设置，防止忘掉

ARGO_DOMAIN/CF_IP/NEZHA_KEY/NEZHA_SERVER/PSWD/SUB_NAME/SUB_URL/UUID/VPATH/PORT

变量添加有2种方式

1、可以直接在Dockerfile里面添加，比如我添加的ENV PW，可以类似添加别的

2、直接在choreo网站部署时设置变量即可，这个基本所有docker容器通用

部署:

1，huggingface 修改USER 1000 ,添加PORT变量为7860

2，choreo 修改USER 10016，无需PORT变量

3，其他docker容器通用，如果不能用基本都可以通过改变USER和PORT变量解决，如render,back4app,可以直接用，koyeb添加PORT 3000改端口3000即可


# 免责声明:

本仓库仅为自用备份，非开源项目，因为需要外链必须公开，但是任何人不得私自下载, 如果下载了，请于下载后 24 小时内删除, 不得用作任何商业用途, 文字、数据及图片均有所属版权。 

如果你使用本仓库文件，造成的任何责任与本人无关, 本人不对使用者任何不当行为负责。
