#!/bin/bash


yum install -y python3 python3-pip git  

mkdir /opt/OneList && cd $_

wget https://raw.githubusercontent.com/MoeClub/OneList/master/Rewrite/amd64/linux/OneList
chmod +x OneList
pip3 install tornado

./OneList -cn -a "OAQABAAIAAABTYj0VqP05TZ6xV9yGkWlGh3pZQcDqj9Prq541jsgzWRU9iyKCyddfA4HQ_H-yJY_J1PXb68742zFCihPnVUVvZi9vu9N_qdqql_Z2TFpfHffc8CqLnTZ9sqO54uNJiJVJ0FtapyCqBgRydcj1ii9tvJgjuCV7frlntxkptNQ9EEK-h9lblbZTqtZdk0TO_7-JzLz_V72X1mA1iMDGIFlVGEBVZVEQaUGDGc5bKXvggZKmAF3DxUFH0_T9M16qv3Zi5ySN0KoSpoBygZKF2mSdbPG5lvlcE-ic4XFMWrL16NvLNcDRV5x78JKgYDVEnEAAWrHY1xnqna6Ef8Et7izwPyjY1P-W_RsK4UDMLBy6u1z9g5oy67xwrM6tXFZbpgu0NYRb-QtYzACwFNLCDMOkr7y4teBEYtZI6yCKdoXuf-aKq1RfwmENqY8Id6ObzmY7YPmQSY-CXmMv4UwQcs4an190VeEwIXcHXwOA6mwrtTXg3blB79UV530fXPEnwrRnjsj_F6CeD0cQkKY3GTcmrz-XevU-pcnc9Ew-IXoDPC2vAjiOQysiT6O1vDJhe1oqS32pEzL8dfQSFwFPp_yHLTJbUtmMPX8SQm19g7Sl8f3akel5fin2krh5AO3OlKQub-RGLA-qs-H7ZNLrGRdgIAA&session_state=15459937-7c6f-492d-a5db-fb79deba030c" -s "/od2"


cat > /opt/OneList/config.json <<EOF
[
  {
    // 如果是家庭版或者个人免费版, 此项应为 true.
    "MSAccount": false,
    // 如果是中国版(世纪互联), 此项应为 true.
    "MainLand": true,
    // 授权令牌
    "RefreshToken": "1234564567890ABCDEF",
    // 单配置文件中,此项要唯一.将此OneDrive中设置为`RootPath`目录映射在`http://127.0.0.1:5288/onedrive` 下.
    // (只推荐一个盘位的时候使用根目录"/".)
    "SubPath": "/od2",
    // 读取OneDrive的某个目录作为根目录. (支持根目录"/")
    "RootPath": "/",
    // 隐藏OneDrive目录中的文件夹和文件, 条目间使用 "|" 分割. (跳过缓存设置的条目.)
    "HidePath": "/Test/Obj01|/Test/Obj02",
    // 使用用户名和密码加密OneDrive目录. 目录和用户名密码间使用 "?" 分割, 用户名密码使用 ":" 分割, 条目间使用 "|" 分割. 无效条目将跳过.
    "AuthPath": "/Test/Auth01?user01:pwd01|/Test/Auth02?user02:pwd02",
    // 缓存刷新间隔.(所有项目中的刷新时间取最小值为有效刷新间隔)
    "RefreshInterval": 900
  }
]

EOF

#下载默认的index.html主题，与config.json同目录，即本文默认的/opt/OneList
wget https://raw.githubusercontent.com/MoeClub/OneList/master/Rewrite/index.html -P /opt/OneList
#监听8000地址，自行修改
/opt/OneList/OneList -bind 0.0.0.0 -port 8000
#最后打开ip:端口访问即可，如果你挂载网盘的时候SubPath为/，那么直接通过根目录查看，如果为/onedrive1，那么通过ip:端口/onedrive1查看，如果该路径不存在，则会提示No Found.。