# 在上传文件的时候需要 git bash 先推送一下，然后用 vscode

# 在 git bash 中上传本地文件夹 BIO 的命令

cd /path/to/BIO
git init
git add .
git commit -m "Initial commit"

# 第一次添加仓库

git remote add origin https://github.com/RONyang-hui/BIO.git

# 更新已经有的仓库

git remote set-url origin https://github.com/RONyang-hui/BIO.git

git push -u origin main
