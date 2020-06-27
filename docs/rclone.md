# rclone 使用

## 挂载网盘到windows中

rclone mount gd1:/ x: --cache-dir "C:\Users\huangchunze\tmp" --vfs-cache-mode writes
rclone mount gd1:/ "C:\Users\huangchunze\disk\" --cache-dir "C:\Users\huangchunze\tmp\" --vfs-cache-mode writes

C:\Users\huangchunze\disk
需要管理员权限安装：https://github.com/billziss-gh/winfsp