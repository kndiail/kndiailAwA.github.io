#!/bin/bash
echo "🚀 Hexo 博客一键部署系统"
echo "======================================"

# 配置信息
GITHUB_REPO="https://github.com/kndiail/kndiailAwA.github.io.git"
SERVER_IP="156.239.254.15"
SERVER_USER="root"
SERVER_REPO="/home/git/myblog.git"

echo "📝 步骤1: 备份源码到 GitHub..."
git add .
git commit -m "自动备份: $(date '+%Y-%m-%d %H:%M:%S')" || echo "⚠️ 无新更改，跳过提交"

if git push origin master; then
    echo "✅ GitHub 备份成功"
else
    echo "❌ GitHub 推送失败，尝试强制推送..."
    git push origin master --force
fi

echo ""
echo "🔨 步骤2: 生成静态文件..."
hexo clean && hexo generate

echo ""
echo "🌐 步骤3: 部署到服务器..."
cd public

if [ ! -d ".git" ]; then
    echo "初始化静态文件仓库..."
    git init
    git remote add deploy $SERVER_USER@$SERVER_IP:$SERVER_REPO
fi

git add .
git commit -m "自动部署: $(date '+%Y-%m-%d %H:%M:%S')" || echo "⚠️ 无新更改"

echo "推送静态文件到服务器..."
if git push deploy master --force; then
    echo "✅ 服务器部署成功"
else
    echo "❌ 服务器部署失败"
fi

cd ..

echo ""
echo "======================================"
echo "🎉 部署完成！"
echo "======================================"
echo "📊 部署结果:"
echo "   ✅ 源码已备份到 GitHub"
echo "   ✅ 网站已部署到服务器"
echo "🌐 访问地址: http://$SERVER_IP"
echo "📁 GitHub: $GITHUB_REPO"
echo "======================================"