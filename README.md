# dbskill

dontbesilent 商业诊断工具箱。从 12,307 条推文中提炼方法论，做成 17 个 Agent skill。

可在 Claude Code、Codex、Cursor、Trae、Manus 等任意支持 skill / system prompt 的 Agent 上使用。

**最新更新：v2.8.0**

**v2.8.0 新增**：目标清晰化（`/dbs-goal`）。帮你把「我想做个人 IP」「我想变得更好」「我想做真正有影响力的内容」这类愿望语法，用维特根斯坦的语言哲学审计成可检查的交付物——三个用法测试 + 空转词识别 + 重写为可指物目标。在 diagnosis 之后、action 之前的一道关。

**v2.7.0 新增**：诊断状态管理三件套（`/dbs-save`、`/dbs-restore`、`/dbs-report`）。诊断不再是单次问诊——这次诊断结束之前 `/dbs-save` 存一份，下次重开对话 `/dbs-restore` 接着走，攒够几次再用 `/dbs-report` 合并成一份可交付的报告。

**作者**：[X](https://x.com/dontbesilent) · [小红书](https://xhslink.com/m/637xuspR4iI) · [抖音](https://v.douyin.com/pRUDhpBqOrc/)

**所有内容开放，可以整套装，也可以只拿一部分。知识包、原子库、单个公理，都能单独用。**

---

## 如何安装 dbskill

![demo](demo.gif)

#### Claude Code

```bash
claude plugin marketplace add dontbesilent2025/dbskill
claude plugin install dbs@dontbesilent-skills
```

#### 通用安装方式（适用于 Codex / Claude Code）

```bash
npx skills add dontbesilent2025/dbskill
```

## 如何更新 dbskill

#### Claude Code 插件市场安装的用户

```bash
claude plugin marketplace update dontbesilent-skills
claude plugin update dbs@dontbesilent-skills
/reload-plugins
```

#### 通过 `npx skills add` 安装的用户

重新运行一次同样的命令即可。安装和更新用的是同一条命令，不需要换成别的写法。

```bash
npx skills add dontbesilent2025/dbskill
```

---

## 工具箱

### dbs 诊断工具

| Skill | 做什么 |
|---|---|
| `/dbs` | 主入口，自动路由到对的工具 |
| `/dbs-diagnosis` | 商业模式诊断。消解问题，不回答问题 |
| `/dbs-benchmark` | 对标分析。五重过滤，排除噪音 |
| `/dbs-content` | 内容创作诊断。五维检测 |
| `/dbs-hook` | 短视频开头优化。诊断 + 生成方案 |
| `/dbs-xhs-title` | 小红书标题公式。75 个爆款公式匹配 |
| `/dbs-ai-check` | AI 写作特征识别。22 条特征扫描，只诊断不改 |
| `/dbs-slowisfast` | 慢就是快。摩擦建造资产，找到值得慢做的环节 |
| `/dbs-action` | 执行力诊断。阿德勒框架（原 dbs-unblock） |
| `/dbs-deconstruct` | 概念拆解。维特根斯坦式审查 |
| `/dbs-goal` | 目标清晰化。把模糊目标审计成可检查的交付物 |

### 状态管理三件套

| Skill          | 做什么                                          |
| -------------- | -------------------------------------------- |
| `/dbs-save`    | 把当前诊断的关键结论、否决方向、推荐下一步存到本地。每次新增不覆盖            |
| `/dbs-restore` | 拉出上次的存档，下次开新对话也能接着诊断              |
| `/dbs-report`  | 把多次存档合并成一份带时间索引的 markdown 报告。可分享、可归档 |

> **几个关键词**
> - **存档**：`/dbs-save` 写到本地的一份诊断状态文件。每次 save 都新增一份，不会覆盖。一个项目下可以攒很多份存档，记录诊断从开始到收尾的全过程。
> - **项目**：用来分隔不同生意的诊断。默认按你当前的目录名隔离——给小红书做的诊断和给线下课做的诊断不会混在一起。
> - **接着上次**：你今天关掉 Claude Code，明天重开。只要还在同一个项目目录里 `/dbs-restore`，就会自动把上次的存档拉回来。

诊断的存档默认放在 `~/.dbs/sessions/{项目名}/`，报告放在 `~/.dbs/reports/{项目名}/`。

### Agent 基建

| Skill | 做什么 |
|---|---|
| `/dbs-agent-migration` | Agent 工作台迁移。把任意项目整理成 Claude Code / Codex 双端一致的 Agent 工作台：审计规则文件、识别真源、统一命名与 bridge |

### chatroom 系列

| Skill | 做什么 |
|---|---|
| `/dbs-chatroom-austrian` 或 `/奥派` | 奥派经济聊天室。哈耶克 × 米塞斯 × Claude 三人对话 |
| `/dbs-chatroom` 或 `/定向聊天室` | 定向聊天室。推荐专家或指定人物，多角色对话 + 判官总结 |

### 工具路径图

#### 常见主线

```text
diagnosis（方向对不对）
    ↓
benchmark（找谁模仿）
    ↓
content（内容怎么做）
```

#### 内容局部优化

```text
content 发现开头问题 → hook（开头怎么优化）
content 需要标题 → xhs-title（标题公式）
content 想检查 AI 味 → ai-check（AI 写作检测）
```

#### 横向工具

```text
goal（目标本身是空转的，无法驱动行动）
slowisfast（任何关键决策阶段：当你在走捷径、贪快、绕开关键摩擦时）
action（知道该做什么，但就是做不动）
deconstruct（概念模糊，导致判断不成立）
chatroom（想先听多个视角，再决定下一步）
```

#### 状态管理（贯穿所有诊断）

```text
任何诊断 skill 走完有结论
    ↓
save（把结论、否决方向、下一步存档到本地）
    ↓
下次回来 → restore（把上次的存档拉回来，接着走）
    ↓
攒了多份存档 → report（合并出可分享的报告）
```

诊断走到「问题被消解」「报告输出」「行动方案确定」这类节点时，相关 skill 会主动建议你 `/dbs-save`。后面回来时一句「接着上次」或 `/dbs-restore` 就能继续，不用从头再讲一遍背景。

Skill 之间会自动推荐下一步。比如：
- diagnosis 发现方向成立但缺具体路径 → 推荐 benchmark
- diagnosis 发现核心卡点是心理或执行 → 推荐 action
- diagnosis 发现用户在关键决策上走捷径 → 推荐 slowisfast
- diagnosis 发现问题里的概念没定义清楚 → 推荐 deconstruct
- diagnosis 发现用户的"问题"其实是个空转目标，原话本身就不能驱动行动 → 推荐 goal
- benchmark 找到对标后，进入具体表达和内容执行 → 推荐 content
- benchmark 发现用户在模仿路径上贪快 → 推荐 slowisfast
- benchmark 发现逃避执行 → 推荐 action
- benchmark 发现用户的目标本身就是模糊的，找不到该模仿谁 → 推荐 goal
- content 发现开头问题 → 推荐 hook
- content 需要起标题 → 推荐 xhs-title
- content 检测出 AI 味 → 推荐 ai-check
- content 发现内容方法上在走捷径 → 推荐 slowisfast
- action 发现不是执行力问题，而是方法选错了 → 推荐 slowisfast
- action 发现用户做不动是因为目标本身就是空转的 → 推荐 goal
- deconstruct 拆完概念后发现整句话是空转目标 → 推荐 goal
- goal 审计通过但用户做不动 → 推荐 action
- goal 审计通过但缺路径 → 推荐 benchmark
- goal 审计通过但牵涉具体内容创作 → 推荐 content / hook / xhs-title
- goal 审计中发现某个词是伪概念 → 推荐 deconstruct
- 任何阶段如果用户想先听不同视角 → 推荐 chatroom
- 任何阶段如果用户用了模糊概念 → 推荐 deconstruct
- 用户明确提到 Claude Code、Codex、`AGENTS.md`、`CLAUDE.md`、skill bridge、工作台迁移、双端统一，或说“我的 Agent 工作台很乱”“帮我统一 Claude 和 Codex” → 推荐 `dbs-agent-migration`
- diagnosis / benchmark / content / action / deconstruct / goal 走到有结论的节点 → 推荐 `dbs-save`
- 用户说「上次」「之前的」「接着」「续上」 → 推荐 `dbs-restore`
- save 累积 ≥3 份存档或用户说「打包」「整理一份」「给合伙人看的」 → 推荐 `dbs-report`

---

## 知识库

dbskill 的知识库是完全开放的。你不需要安装整套 Skill 才能用——可以只拿走你需要的部分。

### 目录结构

```
知识库/
├── 原子库/                     # 结构化知识数据库
│   ├── atoms.jsonl             # 4,176 个知识原子（全量）
│   ├── atoms_2024Q4.jsonl      # 按季度拆分
│   ├── atoms_2025Q1.jsonl
│   ├── ...
│   └── README.md               # 字段说明
│
├── Skill知识包/                 # 提炼后的方法论文档
│   ├── diagnosis_公理与诊断框架.md
│   ├── diagnosis_问题消解案例库.md
│   ├── benchmark_对标方法论.md
│   ├── benchmark_平台运营知识.md
│   ├── content_内容创作方法论.md
│   ├── content_平台特性与案例.md
│   ├── action_心理诊断框架.md
│   ├── action_信号案例库.md
│   ├── deconstruct_语言与概念框架.md
│   └── deconstruct_解构案例库.md
│
└── 高频概念词典.md
```

### 原子库是什么

每个知识原子是一条从推文中提炼的知识点，结构化为 JSON：

```json
{
  "id": "2024Q4_042",
  "knowledge": "判断一个生意能不能做，必要条件之一是你能不能说出这个产品的颜色",
  "original": "判断一个生意能不能做，必要条件之一是你能不能说出这个产品的颜色...",
  "url": "https://x.com/dontbesilent/status/...",
  "date": "2024-10-01",
  "topics": ["商业模式与定价", "语言与思维"],
  "skills": ["dbs-diagnosis", "dbs-deconstruct"],
  "type": "anti-pattern",
  "confidence": "high"
}
```

**字段说明：**

| 字段 | 说明 |
|------|------|
| `knowledge` | 提炼后的知识点 |
| `original` | 推文原文（≤200 字） |
| `topics` | 10 个主题分类（可多选） |
| `skills` | 关联的 Skill |
| `type` | principle / method / case / anti-pattern / insight / tool |
| `confidence` | high / medium / low |

### Skill 知识包是什么

每个 Skill 有 2 个知识包——一个是框架方法论，一个是案例库。Skill 运行时会读取这些文件作为深度参考。

如果你不安装 Skill，也可以直接读这些 .md 文件。它们是独立的、可读的方法论文档。

### 怎么在你自己的项目里用

**场景 1：给你的 AI 加商业诊断能力**

把 `知识库/Skill知识包/diagnosis_公理与诊断框架.md` 的内容粘贴到你的 system prompt 里。你的 AI 就有了 6 公理 + 消解漏斗。

**场景 2：做 RAG 知识库**

把 `知识库/原子库/atoms.jsonl` 导入你的向量数据库。4,176 条结构化知识点，自带主题标签，天然适合检索。

**场景 3：只要案例**

只看 `type: "case"` 或 `type: "anti-pattern"` 的原子。大约 700+ 条真实商业案例和反面案例。

**场景 4：做 chatbot**

用 Skill 知识包里的方法论作为 system prompt，用原子库做 RAG 增强。不需要安装 Claude Code。

**场景 5：学习和研究**

按 `topics` 过滤，只看你感兴趣的领域。比如 `topics` 包含 `"心理与执行力"` 的有 296 条。

---

## 许可证

本项目采用 [CC BY-NC 4.0](https://creativecommons.org/licenses/by-nc/4.0/) 许可证。

- 个人使用、学习、研究、非商业项目：不需要署名，不需要申请
- 公开发布衍生作品（文章、工具、课程等）：请注明来源
- 商业用途：需要单独授权，请联系作者
