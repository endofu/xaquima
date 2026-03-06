# Project Configuration — `.agent/config.md`

> Copy this template to `.agent/config.md` in your host project and fill in the values.

---

## Linear Integration

| Field | Value |
|:---|:---|
| **Workspace** | `your-workspace` |
| **Team Key** | `ENG` |
| **Project Name** | `Your Project` |

---

## Tech Stack

| Field | Value |
|:---|:---|
| **Language** | TypeScript / Python / Go / etc. |
| **Framework** | Next.js / FastAPI / etc. |
| **Runtime** | Node 22 / Python 3.12 / etc. |
| **Package Manager** | npm / pnpm / yarn / pip / etc. |

---

## Commands

| Command | Value |
|:---|:---|
| **Install** | `npm install` |
| **Build** | `npm run build` |
| **Test (all)** | `npm test` |
| **Test (unit)** | `npm run test:unit` |
| **Test (integration)** | `npm run test:integration` |
| **Test (e2e)** | `npm run test:e2e` |
| **Lint** | `npm run lint` |
| **Dev Server** | `npm run dev` |

---

## Conventions

| Field | Value |
|:---|:---|
| **Base Branch** | `develop` |
| **Branch Prefix** | `xq/` |
| **Test Directory** | `tests/` or `__tests__/` |
| **Commit Style** | [Conventional Commits](https://www.conventionalcommits.org/) |

---

## MCP Servers

List any Model Context Protocol servers available to agents:

- `linear-mcp-server` — Linear integration for task management
- *(add others as needed)*

---

## Notes

Add any project-specific notes, quirks, or warnings that agents should be aware of:

- *(e.g., "The database module uses a custom ORM — see `.agent/specs/database.md`")*
- *(e.g., "E2E tests require the dev server running on port 3000")*
