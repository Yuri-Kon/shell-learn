# 条件判断、分支语句、循环语句 2025-11-17

## 条件判断

条件判断最核心的命令是：

- `test`
- `[ ]`
- `[[ ]]`

### 最常见写法：`[ 条件 ]`

```bash
if [ 3 -gt 2 ]; then
  echo "3 > 2"
fi
```

注意：

- 左右必须留空格：`[ 3 -gt 2 ]`
- `]`必须存在
- 中间的每个参数都必须拆开

### 推荐写法：`[[ 条件 ]]`

```bash
if [[ $name == "yuri" ]]; then
  echo "Hello Yuri"
fi
```

相比`[ ]`，`[[ ]]`的优势在于：

- 支持正则表达式
- 不需要给变量加引号
- 更安全(不会被文件名扩展搞乱)
- 支持更复杂逻辑

### 数字比较(整数)

|表达式|含义|
|:-----|:---|
|`-eq`|等于|
|`-ne`|不等于|
|`-gt`|大于|
|`-lt`|小于|
|`ge`|大于等于|
|`le`|小于等于

例子：

```bash
if [[ $a -gt 10 ]]; then
  echo "a > 10"
fi
```

### 字符串比较

|表达式|含义|
|:----|:----|
|`==`或`=`|相等|
|`!=`|不相等|
|`-n s`|字符串非空|
|`-z s`|字符串为空|

例子：

```bash
if [[ -n $name ]]; then
  echo "name 不为空"
fi
```

### 文本判断

|表达式|含义|
|:-----|:---|
|`-e file`|存在|
|`-f file`|普通文件|
|`-d dir`|目录|
|`-r file`|可读|
|`-w file`|可写|
|`-x file`|可执行|
|`file1 -nt file2`|file1比file2更新|
|`file1 -ot file2`|file1比file2更旧|

例：

```bash
if [[ -d /etc ]]; then
  echo "/etc 是目录"
fi
```

### 逻辑运算

`[ ]`写法：

```bash
-a AND
-o OR
! NOT
```

`[[ ]]`写法(推荐)：

```bash
&& AND
|| OR
! NOT
```

例子：

```bash
if [[ $age -ge 18 && $age -le 60 ]]; then
  echo "成年人"
fi
```

### [[ ]]支持正则匹配

```bash
if [[ $str =~ ^[0-9]+$ ]]; then
  echo "数字"
fi
```

## if-elif-else语句

格式：

```bash
if 条件; then
  ...
elif 条件; then
  ...
else
  ...
fi
```

示例：

```bash
if [[ $age -lt 18 ]]; then
  echo "未成年"
elif [[ $age -lt 60 ]]; then
  echo "成年人"
else 
  echo "老年人"
fi
```

## case分支语句(模式匹配)

格式：

```bash
case $变量 in
  模式1)
    命令...
    ;;
  模式2)
    命令...
    ;;
  *)
    默认...
    ;;
esac
```

例子：

```bash
read -p "请输入命令(start/stop/restart): " cmd

case $cmd in
  start)
    echo "启动中"
    ;;
  stop)
    echo "停止中"
    ;;
  restart)
    echo "重启中"
    ;;
  *)
    echo "未知命令"
    ;;
esac
```

支持通配符

## while循环

基本写法:

```bash
while 条件; do
  ...
done
```

例：

```bash
i=1
while [[ $i -le 3 ]]; do
  echo "i=$i"
  ((i++))
done
```

**无限循环**

```bash
while :; do
  ...
done
```

`:`是永远成功的空命令。

## util循环(条件为真时退出)

```bash
util 条件; do
  ...
done
```

一直循环，直到条件判断成功。

例：

```bash
i=0
util [[ $i -eq 3 ]]; do
  echo "i=$i"
  ((i++))
done
```

## for循环

### 遍历列表

```bash
for item in a b c; do
  echo $item
done
```

### 遍历一条命令的输出

```bash
for f in *.txt; do
  echo "文件: $f"
done
```

## break/continue

- break: 跳出循环
- continue: 跳出当前循环

## 例子：输入密码三次失败就输出

```bash
count=0

while [[ $count -lt 3 ]]; do
  read -s -p "请输入密码: " pwd
  echo
  if [[ $pwd == "123456" ]]; then
    echo "登陆成功"
    exit 0
  fi
  echo "密码错误"
  ((count++))
done

echo "失败次数过多，退出"
exit 1
```
