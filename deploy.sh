#!/bin/bash
# Hexo 双仓库部署脚本
# 用法: 
#   ./deploy.sh setup      # 首次设置
#   ./deploy.sh            # 正常部署

SERVER_USER="root"           # 修改为你的服务器用户名
SERVER_IP="156.239.254.15"       # 修改为你的服务器IP
SERVER_REPO="/home/git/myblog.git"

# 首次设置函数
setup() {
    echo "🔧 首次设置双仓库系统..."
    
    # 1. 生成静态文件
    echo "1. 生成静态文件..."
    hexo clean && hexo g
    
    # 2. 进入 public 目录
    cd public
    
    # 3. 初始化独立的 Git 仓库
    if [ ! -d ".git" ]; then
        echo "2. 初始化 public 仓库..."
        git init
        git add .
        git commit -m "首次提交"
    fi
    
    # 4. 添加服务器远程仓库
    echo "3. 添加服务器仓库..."
    git remote add deploy $SERVER_USER@$SERVER_IP:$SERVER_REPO 2>/dev/null
    if [ $? -ne 0 ]; then
        echo "   已存在，更新地址..."
        git remote set-url deploy $SERVER_USER@$SERVER_IP:$SERVER_REPO
    fi
    
    # 5. 首次推送
    echo "4. 首次推送代码到服务器..."
    git push -u deploy master --force
    
    echo ""
    echo "======================================"
    echo "✅ 设置完成！"
    echo "======================================"
    echo "下次部署只需运行: ./deploy.sh"
    echo "======================================"
    
    cd ..
}

# 正常部署函数
deploy() {
    echo "🚀 开始部署..."
    
    # 1. 备份 GitHub 更改
    echo "1. 备份源码到 GitHub..."
    git add .
    git commit -m "更新: $(date '+%Y-%m-%d %H:%M')" || echo "无更改，跳过提交"
    git push origin master
    
    # 2. 生成静态文件
    echo "2. 生成静态文件..."
    hexo clean && hexo g
    
    # 3. 部署到服务器
    echo "3. 部署到服务器..."
    cd public
    git add .
    git commit -m "自动部署: $(date '+%Y-%m-%d %H:%M:%S')"
    git push deploy master
    
    echo ""
    echo "======================================"
    echo "✅ 双仓库部署完成！"
    echo "======================================"
    echo "✅ 源码已推送到 GitHub"
    echo "✅ 网站已部署到服务器"
    echo "======================================"
    echo "网站地址: http://$SERVER_IP"
    echo "GitHub 仓库: https://github.com/你的用户名/myblog"
    echo "======================================"
    
    cd ..
}

# 脚本主逻辑
case "$1" in
    setup)
        setup
        ;;
    *)
        deploy
        ;;
esac
