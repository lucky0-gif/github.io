[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
# PowerShell 自动部署脚本：将本地 E:\blog 替换 GitHub 仓库 lucky0-gif/github.io 的全部内容


# 参数配置
$LocalDir = "E:\New-blog"
$RepoURL  = "https://github.com/lucky0-gif/github.io.git"
$Branch   = "main"
$TempDir  = "$env:TEMP\repo_deploy_tmp"

# 步骤 1：清理旧临时目录
if (Test-Path $TempDir) {
    Remove-Item -Recurse -Force $TempDir
}

# 步骤 2：克隆仓库到临时目录
git clone $RepoURL $TempDir

# 步骤 3：进入临时仓库目录
Set-Location $TempDir

# 步骤 4：删除旧文件（保留 .git）
Get-ChildItem -Force | Where-Object { $_.Name -ne ".git" } | Remove-Item -Recurse -Force

# 步骤 5：复制本地文件（含隐藏文件）
Copy-Item "$LocalDir\*" . -Recurse -Force
Copy-Item "$LocalDir\.*" . -Recurse -Force -ErrorAction SilentlyContinue

# 步骤 6：提交并推送
git add .
git commit -m "自动提交：从 E:\blog 全量更新项目文件"
git push origin $Branch

# 完成提示
Write-Host "`n✅ 部署完成：E:\blog 的内容已同步到 GitHub 仓库 https://github.com/lucky0-gif/github.io"
