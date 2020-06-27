# 压缩命令使用

## 一、常用压缩软件

### winrar

```bash
# 使用rar分卷压缩: 最大限制为 12M
rar a -m5 -v12m myarchive myfiles
# 解压
rar e myarchive.part1.rar
```

### 7z

```bash
yum install -y p7zip
# p7zip-full ：如果安装的是p7zip，只存在7zr这一个解压缩工具；如果安装的是p7zip-full，就有三个解压缩工具：7zr，7za和7z

7za x 文件

```

## 二、压缩高端应用场景

### 2.1 分卷压缩

使用rar分卷压缩:

rar a -m5 -v12m myarchive myfiles
# 最大限制为 12M

rar e myarchive.part1.rar
#解压



详解：

Ubuntu下没有默认安装rar，可以通过

sudo apt install rar
sudo apt install unrar
来安装rar.

安装过后，使用以下命令进行分卷压缩：

rar a -vSIZE  压缩后的文件名 被压缩的文件或者文件夹

例如：

rar a -v50000k eclipse.rar eclipse
此命令即为对eclipse文件夹进行分卷压缩，每卷的大小为50000k，压缩后的文件名为eclipse.rar
 

2.用tar

举例说明：

要将目录logs打包压缩并分割成多个1M的文件，可以用下面的命令：

tar cjf - logs/ |split -b 1m - logs.tar.bz2.
完成后会产生下列文件：
 logs.tar.bz2.aa, logs.tar.bz2.ab, logs.tar.bz2.ac
要解压的时候只要执行下面的命令就可以了：

cat logs.tar.bz2.a* | tar xj
再举例：
要将文件test.pdf分包压缩成500 bytes的文件：

tar czf - test.pdf | split -b 500 - test.tar.gz
最后要提醒但是那两个"-"不要漏了，那是tar的ouput和split的input的参数。



3、用7z



在上层目录操作，保留film目录名
压缩：

7z a name.7z filename -v10m
#这里a是添加文件到压缩卷，name.7z是压缩后文件,然后filename可以是文件夹或文件，-v10m是限制每个包大小不超过10m.



解压到当前目录：

7z x film.7z.001
解压到目录a:

mkdir a && cd a && 7z x ../film.7z.001
或者 

7z -oa x film.7z.001
不保留film目录名：

压缩：

cd film && find . | xargs 7z a film.7z -v80m
解压：

7z -oa x film.7z.001
单纯采用7z的话，文件的权限（拥有者）属性会丢失， 采用如下办法则可以保留： 
压缩：

tar cf - film | 7z a -si film.tar.7z -v80m
解压缩：

7z x -so film.tar.7z.001 | tar xf -