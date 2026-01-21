# 第一组 基础命令+重定向

## 文件和目录(ls/wc)

### 统计文本文件个数

在`texts`目录下，用一行命令统计当前目录下有多少个.txt文件

```bash
ls texts/*.txt | wc -l
```

### 列出大文件

在`logs`目录下，按文件大小从大到小列出所有文件

```bash
ls -lS logs/
```

### 把文件列表保存到文件里

在`shell-practice/`下，把所有子目录里的`.log`文件路径列出来并写入`all-logs.txt`

```bash
find . -name "*.log" > all-logs.txt
```

`find`用法可见：[find用法](../../notes/Day2/day2.md#find)

### 追加内容

再次列出当前目录下的`.txt`文件，把结果追加到`all-logs.txt`的末尾

```bash
find . -name "*.txt" >> all-logs.txt
```

## 文本统计(wc/head/tail)

### 统计日志行数

统计`logs/app.log`有多少行

```bash
wc -l < logs/app.log
```

### 统计字符和单词

统计`texts/a.txt`的行数、单词数、字节数

```bash
wc -lwc texts/a.txt
```

### 查看文件开头/末尾

显示`logs/app.log`的前两行

```bash
head -n 2 logs/app.log
```

显示`logs/app.log`的最后一行

```bash
tail -1 logs/app.log
```

### 把统计内容写入报告

把`logs/app.log`的行数信息写入`report.txt`，格式类似：

```bash
app.log lines: 3
```

```bash
echo "app.log lines: $(wc -l < logs/app.log)" > report.txt
```

## 文本替换

### 大小写替换

将`texts/a.txt`中的所有字母转换为大写并打印到屏幕

```bash
tr 'a-z' 'A-Z' < texts/a.txt
```

### 删除某些字符

把`texts/c.txt`里的所有数字删除，之留下字母与换行显示

```bash
tr -d '0-9' < texts/c.txt
```

### 合并连续空格

自己写一段包含很多重复空格的字符串，通过`echo`管道给`tr`，把连续空格压缩成一个空格

```bash
echo "a          b         s        w" | tr -s ' '
```

# 管道+多命令组合

把`rg/wc/ls/tr`串起来

## `rg`+管道

### 查找包含ERROR的日志行数

在`logs/app.log`中，查找包含`ERROR`的行，一共有多少行？

```bash
rg "ERROR" logs/app.log | wc -l
```

等价于：  
```bash
rg -c "ERROR" logs/app.log
```

### 统计包含GET的访问数

在`logs/web.log`中，统计有多少行包括`GET`

```bash
rg -c "GET" logs/web.log
```

### 忽略大小写搜索

在`texts`目录中，忽略大小写搜索单词`apple`，统计出现的总行数

```bash
rg -i "apple" texts | wc -l
```

`-i`忽略大小写，`-c`直接统计行数

## rg+tr+sort+uniq

### 统计某文件中每个单词的出现次数

对texts/b.txt:

- 把所有大写变成小写
- 把空格变成换行
- 去掉空行
- 按字典顺序排序
- 统计每个单词出现次数
- 最后行数最多的单词排在最后


