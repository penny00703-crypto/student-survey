# 51Talk 家长问卷 · Supabase 版部署说明

整个网站是纯静态页面（无需自己的服务器），数据全部进你的 Supabase。共 3 步，约 10 分钟。

## 第 1 步：初始化 Supabase（约 3 分钟）

1. 打开 <https://supabase.com> 登录，**New project** 创建一个项目（区域建议选新加坡/法兰克福，离沙特较近；免费版够用）。
2. 进入项目 → 左侧 **SQL Editor** → 新建查询 → 把本目录 `setup.sql` 的**全部内容**粘进去 → **Run**。
   这一步会自动建好：数据表 `submissions`、图片存储桶 `covers`、以及匿名读写权限。

## 第 2 步：填配置（1 分钟）

1. Supabase 项目 → **Settings → API**，复制两项：
   - `Project URL`
   - `anon public` key
2. 打开本目录 `config.js`，替换两行：

```js
const SUPABASE_URL = 'https://xxxx.supabase.co';   // 你的 Project URL
const SUPABASE_ANON_KEY = 'eyJhbG...';             // 你的 anon public key
```

## 第 3 步：挂到 GitHub Pages（约 5 分钟）

1. 在 GitHub 新建一个仓库（Public，名字随意，如 `parent-survey`）。
2. 把本目录的 4 个文件传上去（网页端 Add file → Upload files 直接拖进去即可）：
   - `index.html`（家长问卷页）
   - `admin.html`（数据后台）
   - `config.js`（已填好 key 的）
   - `logo.png`
3. 仓库 → **Settings → Pages** → Source 选 `main` 分支根目录 → Save。
4. 等 1–2 分钟，得到网址：

| 给谁 | 地址 |
|---|---|
| 家长 | `https://你的用户名.github.io/parent-survey/` |
| 你自己（后台） | `https://你的用户名.github.io/parent-survey/admin.html` |

> 不想用 GitHub 也行：把同样 4 个文件拖到 Vercel / Netlify / Cloudflare Pages 的任意一个，效果相同，都是免费。

## 使用说明

- **看数据**：打开 `admin.html`（无密码，链接自己保管好）。顶部是统计，支持搜索、删除单条。
- **导出**：后台右上角「导出 Excel」，下载 .xlsx，含全部字段双语表头；封面图一列是图片 URL，点开可看原图。
- **备用入口**：也可以直接在 Supabase → Table Editor → `submissions` 里看原始数据。

## 安全说明（重要）

按你的要求后台**没有密码**。因为 anon key 会出现在网页源码里，技术上任何人都可以通过接口读到/删改数据。问卷内容敏感度低、且别人要主动去翻接口才行，一般可接受。如果以后想加防护，告诉我，加 Supabase Auth 登录即可，改动很小。
