# 在上传文件的时候需要 git bash 先推送一下，然后用 vscode

# 在 git bash 中上传本地文件夹 BIO 的命

# 开始工作前要拉取仓库

cd /path/to/BIO
git init
git add .
git commit -m "Initial commit"

# 第一次添加仓库时需要在远程建立有个仓库

git remote add origin https://github.com/RONyang-hui/BIO.git
git remote add origin https://github.com/RONyang-hui/ExcelUse.git

# 第一次添加仓库时需要在远程建立有个仓库
# 更新已经有的仓库

git remote set-url origin https://github.com/RONyang-hui/BIO.git
git remote set-url origin git@github.com:RONyang-hui/sepsisEcho.git

# 不能http推送就用SSH
git remote set-url origin git@github.com:RONyang-hui/sepsisEcho.git
git push -u origin main

需要先拉取


git checkout master  # 切换到 master 分支
git branch -m main   # 将 master 分支重命名为 main
git push -u origin main  # 推送 main 分支到远程仓库