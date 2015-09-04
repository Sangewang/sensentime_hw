
##1 项目要求
###1.1  OptionParser使用
####1.1.1   按照要求启动FTP server  &nbsp;
#####  Usage: 001-ftp-server/myftp.rb [options]
#####       -p, --port = PORT       监听端口号
####            --host = HOST       绑定IP地址
####            --dir  = DIR        改变当前目录
####        -h                      帮助列表
###1.2  Logger使用
###1.3  实现FTP命令
####1.3.1 USER/PASS 输入用户名和密码
####1.3.2 LIST      显示当前目录的文件列表
####1.3.3 CWD 
####1.3.4 PERT
####1.3.5 STOP      停止FTP服务
###1.4多线程/进程支持，可支持多同时连接
##2 扩展需求
###2.1  额外的ftp命令：delete mkdir m put m get
###2.2  读写权限，访问文件的路径安全性控制
###2.3  IPV6支持
###2.4  可扩展用户验证机制，如连接sqlite数据库验证用户身份
###2.5  可自行添加特色功能
  
