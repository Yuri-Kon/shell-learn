count=0

while [[ $count -lt 3 ]]; do
  read -s -p "请输入密码: " pwd
  if [[ $pwd == "123456" ]]; then
    echo "登陆成功"
    exit 0
  fi
  echo "密码错误"
  ((count++))
done

echo "失败次数过多，退出"
exit 1
