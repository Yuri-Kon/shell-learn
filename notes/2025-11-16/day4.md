# 读取输入与传参、重定向 2025-11-16

## 重定向

### Shell重定向的底层原理

> shell中一切输入输出都是通过 **文件描述符** (File Descriptor,FD)控制的。

在Linux中，

|文件描述符|含义|
|:---------|:---|
|0|标准输入|stdin|
|1|标准输出|stdout|
|2|标准错误|stderr|

例如执行一个命令：

```bash
ls
```

其实是：

- 从 **FD 0** 读取
- 输出到 **FD 1**
- 错误通过 **FD 2** 输出到终端

所谓重定向就是， **把FD 0/1/2指向另外一个地方**：文件、设备、管道等

### 输出重定向(> 和 >>)

#### 标准输出重定向(覆盖)

```bash
command > file
```

等价于：

```bash
command 1> file
```

把命令的标准输出写到file(覆盖)。

比如：

```bash
echo hello > output.txt
```

#### 标准输出重定向(追加)

```bash
command >> file
```

等价于：

```bash
command 1>> file
```

### 错误重定向(2> 和 2>>)

#### 把错误单独写到文件

```bash
command 2> error.log
```

例子：

```bash
ls not_exist 2> err.txt
```

#### 错误追加

```bash
command 2>> error.log
```

### 标准输出+错误输出同时重定向

#### bash专用 &>

```bash
command &> all.log
```

等价于：

```bash
command > all.log 2>&1
```

#### 追加 &>>

```bash
command &>> all.log
```

### 输入重定向(<)

```bash
command < file
```

把file的内容当作stdin提供给command

例子：

```bash
wc -l < myfile.txt
```

相当于：

```bash
cat myfile.txt | wc -l
```

### Here Document

用于给命令传递多行内容

结构：

```bash
command << EOF
内容1
内容2
EOF
```

### Here String

```bash
command <<< "string"
```

例子：

```bash
wc -c <<< "hello world"
```

### 黑洞重定向(/dev/null)

丢弃输出/错误/全部丢弃：

```bash
command > /dev/null
command 2> /dev/null
command >/dev/null 2>&1
```

### 更灵活的FD操作

#### 复制FD

```bash
2>&1 # 把错误输出复制到当前stdout所指向的位置
1>&2 # 把标准输出复制到stderr
```

#### 关闭FD

```bash
command 2>&- # 等价于关闭错误输出，不会显示任何错误
```

## 读取输入与传参

### Shell读取用户输入：`read`命令

`read`命令是Bash读取用户输入的最基本机制

最基本语法：

```bash
read 变量名
```

示例：

```bash
echo "请输入你的名字："
read name
echo "你好，${name}"
```

## read常用参数

**`-p`提示文字**

```bash
read -p "请输入用户名：" user
```

**`-s`隐藏输入(用于密码)**

```bash
read -s -p "请输入密码:" passwd
echo
echo "你的密码是: ${passwd}"
```

**`-n`只读n个字符**

```bash
read -n 1 -p "确认删除?(y/n)" ans
echo
echo "你的选择是: ${ans}"
```

**`-t`设置超时**

```bash
read -t 5 -p "5秒内输入内容:" input
echo "你输入的是${input}"
```

**`-r`原样读取，不解释反斜杠**

```bash
read -r line
```

默认情况下`read`会把`\`当作转义字符，用`-r`可以关闭这个行为

**多变量读取**

```bash
read a b c
```

输入：`1 2 3`  
结果：

- a=1
- b=2
- c=3

如果输入字段比变量多，最后一个变量会获得剩余全部内容

### 脚本传参

当执行一个脚本时，后面跟的参数会自动传递给脚本：

```bash
./myscript.sh arg1 arg2 arg3
```

---

Bash 内建了几个位置参数变量

- **$0：脚本本身的文件名**
- **`$1, $2, $3...`** ：脚本的第1、2、3个参数
- **$#** : 参数个数

### 所有参数: `$*` vs. `$@`

这两个都意味着所有参数，但是有着非常关键的区别：

|表达式|含义|作为单独参数传递时|
|:---|:-----|:-----------------|
|`$*`|所有参数|合在一起|
|`$@`|所有参数|逐个参数传递|

例子：

```bash
set -- "a b" c
```

此时有两个参数：

- 第一个：`a b`
- 第二个：`c`

`$*`

```bash
"$*"
```

结果是：

```bash
a b c # 被拼为一个参数
```

`$@`

```bash
"$@"
```

结果是：

```bash
"a b" "c" # 保持独立参数，不会破坏空格结构
```

在脚本中传递参数时，一律用`$@`，永远正确。

### shift: 左移参数(常用于循环处理参数)

```bash
shift
```

会移除`$1`, 原`$2`变成`$1`，以此类推

例子：

```bash
#!/usr/bin/bash

echo "总参数: $#"

while (($# > 0))
do
  echo "当前参数: $1"
  shift
done
```


