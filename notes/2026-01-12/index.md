# 快速复建

## 文本处理三板斧

### 统一一个底层模型

```
文本流 -> 过滤 -> 变形 -> 输出
```

| 工具 | 角色                  |
| :--- | :-------------------- |
| rg   | 定位文本(过滤)        |
| sed  | 行级修改(替换/删除)   |
| awk  | 结构化处理(字段/逻辑) |
| less | 安全查看              |

**Shell 的强大在于通过管道的组合**:

```bash
A | B | C
```

______________________________________________________________________

### ripgrep(rg): 现代文本搜索核心工具

#### ripgrep 的定位

rg =

- grep + recursive
- grep + ignore binary
- grep + respect .gitignore
- grep + regex

______________________________________________________________________

#### ripgrep 的基础用法

```bash
rg keyword
```

等价于:

- 在当前目录
- 递归
- 只搜索文本文件
- 自动忽略 .gitignore

______________________________________________________________________

#### 高频参数

##### 显示行号

```bash
rg -n keyword
```

##### 忽略大小写

```bash
rg -i keyword
```

##### 只在特定文件类型中搜索

```bash
rg keyword -t py
rg keyword -t md
rg keyword -t rust
```

或者查看支持的类型:

```bash
rg --type-list
```

##### 指定路径

```bash
rg keywork src/
rg keyword docs/
```

______________________________________________________________________

#### 正则搜索

```bash
rg 'error|failed|panic'
rg 'def\s+\w+'
rg 'TODO|FIXME'
```

rg 默认就是正则。这就是它比 grep 现代的地方之一。

#### 只看匹配内容

```bash
rg -o '\d{4}-\d{2}-\d{2}'
```

只输出匹配部分，便于后续管道处理。

#### 验证与统计类用法

```bash
rg keyword -c # 每个文件匹配次数
rg keyword -l # 只列出文件名
rg keyword -L # 列出不匹配的文件
```

### rg + 管道

#### 与 less 结合(安全查看)

```bash
rg error | less
```

#### 与 sort / uniq 结合(快速分析)

```bash
rg ERROR log.txt | sort | uniq -c
```

```bash
rg 'Exception:' app.log | awk '{print $NF}' | sort | uniq -c
```

______________________________________________________________________

### sed: 行级文本修改

#### sed 的正确理解方式

> sed = stream editor

- 一行一行读
- 默认输出到 stdout
- 除非 -i ，否则不改原文件

______________________________________________________________________

#### 替换

```bash
sed 's/foo/bar' file.txt
sed 's/foo/bar/g' file.txt
```

```bash
sed -i 's/foo/bar/g' file.txt # 就地修改
```

> `sed 's/old/new/g'`
> 意思是把 `old` 修改为 `new` ，并展示到屏幕上，但是不操作文件
> 添加参数 `-i` 才会直接修改文件

#### 与 rg 联合

```bash
rg foo -l | xargs sed -i 's/foo/bar/g'
```

> 使用 `rg` 寻找所有包含 `foo` 的文件，并通过 `xargs` 传递给 `sed` , 在 `sed` 中执行 将 `foo` 替换为 `bar` .

#### 删除行

```bash
sed '/DEBUG/d' log.txt
```

______________________________________________________________________

### awk: 结构化文本处理

#### awk 的定位

> 当文本是"按列有意义"时，使用 awk

例如:

- ps aux
- ls -l
- CSV/TSV
- 日志格式化输出

#### 最基础语法

```bash
awk '{print $0}' # 打印整行内容
awk '{print $1}' # 打印第一个字段
awk '{print $2, $3}' # 打印第二、第三个字段
awk '{print $NF}'
```

字段默认用空格分隔

#### 与 rg 联合

```bash
rg ERROR app.log | awk '{print $1, $NF}'
```

```bash
ps aux | awk '$3 > 10 {print $1, $3, $11}' # 将所有CPU占用>10%的进程的名称、CPU占用以及COMMAND打印在屏幕上
```

#### 简单逻辑判断

```bash
awk '$2 > 100 {print $0}' # 第二列 > 10 就打印整行内容
```

## 筛选·排序·聚合

> 这一阶段的目标是:
> 从 "很多行文本" 中，快速提炼出 "有结构的信息"

______________________________________________________________________

### 筛选(Filtering)

#### head/tail -- 最基础的截断器

```bash
head file.txt # 默认打印前10行文本
head -n 20 file.txt # 打印前20行文本
```

```bash
tail file.txt # 默认打印后10行的文本
tail -n 50 file.txt # 默认打印后10行的文本
tail -f app.log # 实时输出文件末尾的内容
```

#### 管道中的 head/tail

```bash
rg ERROR app.log | head -n 20
rg ERROR app.log | tail -n 10
```

**用途**:

- 防止输出爆炸
- 快速验证管道是否正确

#### wc -- 计数器

```bash
wc -l file.txt # 行数
wc -w file.txt # 单词数
wc -c file.txt # 字节数
```

```bash
rg ERROR app.log | wc -l
```

______________________________________________________________________

### 排序(Sorting): 让信息呈现结构

#### sort 的基本用法

> sort 以行为单位, 对 stdin 或 文件 进行排序, 并将结果输出到 stdout

默认:

- 字典顺序
- 升序

#### 高频参数

```bash
sort -n # 对数值排序
sort -r # 反序
sort -u # 去重(常与uniq对比)
```

```bash
sort -k 2 # 以行为单位, 按照第二列对所有行的顺序进行排序
sort -k 2,2 # 严格第二列
```

#### 混合使用

```bash
rg ERROR app.log \
  | awk '{print $NF}'\ # 打印最后一个字段
  | sort \ # 进行默认排序
  | uniq -c \ # 计数, 在每个输出行前加上出现的次数
  | sort -nr \ # 对数值进行反序排序
```

______________________________________________________________________

### uniq: 去重与聚合

> uniq 只能处理 **相邻重复行**

因此:

```bash
sort | uniq
```

才是标准组合

#### 常见用法

```bash
uniq
uniq -c # 计数
uniq -d # 只显示重复行
```

#### 错误示范

```bash
rg keyword | uniq # 通常是错的, 因为 uniq 只能匹配相邻行. 这样无法合并隔行重复的
```

______________________________________________________________________

### 筛选(条件级): awk 条件过滤

当 `rg` 只能做"文本级"过滤时,
**awk** 才是"字段级过滤".

#### 条件筛选

```bash
awk '$2 > 100'
```

```bash
ps aux | awk '$3 > 10 {print $1, $3, $11}'
```

#### 与 rg 联合(标准工程用法)

```bash
rg ERROR app.log \
  | awk '$5 >= 500'
```

---

### 典型 流程模板

#### 模板 1: 日志错误统计

```bash
rg ERROR app.log \
  | awk '{print $NF}' \
  | sort \
  | uniq -c \
  | sort -nr \
  | head
```

#### 模板 2: 规模评估

```bash
rg TODO  src/ | wc -l
```

#### 模板 3: 快速抽样

```bash
rg panic log.txt | head -n 10
```


