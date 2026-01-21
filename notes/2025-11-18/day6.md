# 命令组合与管道

## 管道的原理

### 定义

管道`|`会直接将左侧命令的stdout直接连接到右侧命令的stdin

```bash
command1 | command2 | command3
```

内部作用：

- command1的stdout -> 一个匿名管道文件
- command2从该管道读取，输出 stdout并传递到下一个管道
- 流水线式处理数据

### 典型示例：过滤、统计、搜索

**示例1：找出包含error的日志行数**

```bash
grep error app.log | wc -l
```

**示例2：查看文件中出现最多的10个单词**

```bash
tr -c '[:alnum:]' '\n' < file.txt \
| tr '[:upper:]' '[:lower:]' \
| sort \
| uniq -c \
| sort -nr \
| head
```

## 管道右侧接收stdout

管道只会传递stdout,不会传递stderr。

示例：

```bash
ls nofile | wc -l
```

会看到报错:  
```bash
ls: cannout access 'nofile': No such file or direcory
0
```

因为：

- error信心是stderr,不会流入管道
- wc只受到了空的stdout,所以输出为0

如果需要把stderr一起放进管道，需要  
```bash
ls nofile 2>&1 | wc -l
```

`2>&1`: 把stderr(2)重定向到stdin(1)

## 管道与tee：同时输出到文件和下一命令

`tee`是管道方向的分流器：  
```bash
command | tee output.txt | another-command
```
作用：

- stdout -> 写入output.txt
- 同时继续传递到another-command

例子：  
```bash
echo "hello" | tee a.txt | tr a-z A-Z
```
显示：  
```bash
HELLO
```
文件a.txt的内容是：  
```bash
hello
```

## 命令逻辑控制：&&与||

管道是"数据流"，逻辑控制就是"执行流"

### `&&`——前一命令成功(退出码为0)才执行下一命令

```bash
mkdir data && cd data
```
如果 `mkdir data`成功，则执行`cd data`  
失败则不执行  

### `||`——前一命令失败(退出码非0)才执行下一命令

```bash
make || echo "build failed"
```

### 组合：成功做这个，失败做另一个

```bash
command && { echo OK; } || { echo FAIL; }
```

## 命令组：()与{}

### 子shell: `()`

```bash
(cd /tmp && ls)
echo ""当前目录还是原来的"
```

### 当前shell: `{}`

```bash
{ echo 1; echo 2; } > output.txt
```

- 必须要用空格: `{ echo 1; }`
- 最后的`}`后要跟分号或换行

`{}`不会创建子shell,常用于对多个命令整体重定向。

## 命令序列`;`

简单串行:

```bash
cmd1; cmd2; cmd3
```
按顺序执行
