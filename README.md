# Promotion Advisor — Multi-Agent System with LangGraph + MongoDB Atlas

> AI-powered promotion packet preparation: define your target role, document your projects, generate an impact analysis, and discover similar professionals — all orchestrated with **LangGraph**, persisted in **MongoDB Atlas**, and wrapped in a **Gradio** UI.

---

## 🎯 What This Does

A **practical AI workflow** that helps you prepare for career advancement:

- **🎯 Target Role Builder** → Define your promotion goal (e.g., *Staff Engineer*, *Senior PM*, *VP of AI*)
- **📁 Project Curator** → Extract structured project records with metrics from free text  
- **📊 Impact Analyzer** → Generate executive-ready reports with strengths, gaps, and recommendations
- **👥 Mentor Finder** → Discover similar professionals on LinkedIn (via Tavily search)
- **⬇️ Export** → Download a complete promotion packet in Markdown

---
## 🎬 See It In Action

![Workflow](screenshots/app-finished-running.png)

**📺 Watch the full demo walkthrough:** [AI-Powered Promotion Advisor - Complete Demo (3 min)](https://youtu.be/mYr4xmX3lgA)

[![Promotion Advisor Demo](https://img.youtube.com/vi/QmQUIXzQ7To/maxresdefault.jpg)](https://youtu.be/QmQUIXzQ7To)

*Click the image above to watch the full demonstration on YouTube*

<details>
<summary>📸 More Screenshots</summary>

### Initial Interface
![Clean UI](screenshots/whole-app-clean.png)


### Complete Workflow
![Top Panel](screenshots/whole-app-top.png)
---
![Middle Panel](screenshots/whole-app-middle.png)
---
![Bottom Panel](screenshots/whole-app-end.png)

### Generated Impact Report
![Impact report with industry data](screenshots/components-impact-report.png)

### Agent Execution Trace
![Technical workflow](screenshots/component-execution-trace.png)

</details>

---

## 🚀 Quick Start

### 1. Clone the repository
```bash
git clone https://github.com/mikikob-mongodb/datacamp-mcp-multiagent-demo.git
cd datacamp-mcp-multiagent-demo
git checkout v1_webinar_version
```

### 2. Set up environment variables
```bash
cp env.template .env
```

Edit `.env` and add your API keys:
```env
OPENAI_API_KEY=sk-your-key-here
MONGODB_URI=mongodb+srv://your-connection-string
TAVILY_API_KEY=tvly-your-key-here  # Optional
```

**Get your API keys:**
- **OpenAI**: https://platform.openai.com/api-keys ($5 minimum credit)
- **MongoDB Atlas**: https://www.mongodb.com/cloud/atlas/register (free M0 cluster)
- **Tavily** *(optional)*: https://tavily.com (1,000 free searches/month)

### 3. Install dependencies
```bash
make setup
```

This will:
- Kill any processes on port 7860
- Create a virtual environment
- Install all required packages
- Set up development tools (linters/formatters)

### 4. Run the application
```bash
source .venv/bin/activate  # Windows: .venv\Scripts\activate
make run
```

Open your browser to: **http://localhost:7860**

---

## 📋 How It Works

1. **Start** → Chat interface asks: *"What role are you targeting?"*
2. **Define Role** → AI parses your goal and sets expectations (focus areas, responsibilities, success metrics)
3. **Add Projects** → Paste project descriptions; AI extracts context, actions, outcomes, and metrics
4. **Generate Report** → Get executive-ready impact analysis with:
   - Strengths backed by specific evidence
   - Gaps to address
   - Actionable recommendations
   - Industry salary data (if Tavily enabled)
5. **Find Mentors** *(optional)* → Discover LinkedIn profiles of professionals in similar roles
6. **Download** → Export complete promotion packet as Markdown

---

## 🛠️ Development Commands

### Available Make Commands

```bash
make setup       # Create venv and install all dependencies
make run         # Run the application (kills port first)
make lint        # Check code for issues
make format      # Auto-fix and format code
make clean       # Remove cache files
make clean-all   # Remove cache files AND venv
make kill-ports  # Kill process on port 7860
make help        # Show all available commands
```

### Full Reset Script

For a complete fresh start (useful during development or debugging):

```bash
./reset.sh
```

**What `reset.sh` does:**
1. Checks if you're in a virtual environment and warns you
2. Deactivates the venv (within the script's context)
3. Runs `make clean-all` to remove all caches and the venv directory
4. Runs `make setup` to create a fresh environment and install dependencies
5. Provides clear instructions for activating the new environment

**After running `reset.sh`, activate the new environment:**
```bash
source .venv/bin/activate && make run
```

**Note:** The script cannot automatically activate the venv in your terminal (this is a fundamental shell limitation). Your terminal prompt may still show `(.venv)` after the reset, but the old environment has been removed and a fresh one created. Simply run the activation command above to use the new environment.

---

## 📁 Project Structure

```
promotion_tycoon/
  ├── main.py              # Application entry point
  ├── config.py            # Environment configuration
  ├── storage.py           # MongoDB operations & checkpointer
  ├── models.py            # Pydantic data models
  ├── prompts.py           # System prompts
  ├── tracing.py           # Execution logging
  └── ui.py                # Gradio interface

├── env.template           # Environment variables template
├── Makefile              # Build and run commands
├── reset.sh              # Development reset script
└── README.md             # This file
```

---

## 🔧 Configuration

### Environment Variables (.env)

```env
# Required
OPENAI_API_KEY=sk-...
MONGODB_URI=mongodb+srv://...

# Optional
TAVILY_API_KEY=tvly-...           # For industry research
DATABASE_NAME=promotion_advisor    # Default database name
GRADIO_SERVER_PORT=7860           # Default port
```

### MongoDB Atlas Setup

1. **Create a free M0 cluster** at https://www.mongodb.com/cloud/atlas
2. **Create a database user** with read/write permissions
3. **Get your connection string** (looks like `mongodb+srv://username:password@cluster.mongodb.net/`)
4. **Whitelist your IP** in Network Access settings
5. **Add to `.env` file**

**Fallback behavior:** If MongoDB is unavailable, the app automatically falls back to in-memory storage with a warning message in the logs.

---

## 🎓 Key Concepts Demonstrated

This project showcases several advanced patterns for building production-ready AI applications:

- **Multi-Agent Orchestration** → LangGraph manages routing between specialized agents
- **Interrupt/Resume Patterns** → Human-in-the-loop workflows with checkpoint/resume
- **Structured Data Extraction** → Pydantic models ensure type safety and validation
- **Persistent Memory** → MongoDB Atlas stores conversation state and checkpoints
- **Industry Research Integration** → MCP (Model Context Protocol) with Tavily for real-time data
- **Interactive UI** → Gradio provides rapid prototyping with production-ready interfaces
- **Graceful Degradation** → App continues functioning even if external services fail

---

## 🐛 Troubleshooting

### Port Already in Use

If you see "Cannot find empty port" error:

```bash
make kill-ports
make run
```

Or specify a different port in `.env`:
```env
GRADIO_SERVER_PORT=7861
```

### MongoDB Connection Failed

**Symptoms:** `Authentication failed` or `Connection timeout`

**Solutions:**
- Verify your connection string in `.env` is correct
- Check database user has proper read/write permissions
- Ensure your IP address is whitelisted in Atlas Network Access
- Test connection string with MongoDB Compass

**The app will automatically fall back to in-memory storage if MongoDB is unavailable.**

### Dependencies Not Installing

Make sure you have Python 3.10+ installed:
```bash
python3 --version
```

If you encounter dependency conflicts:
```bash
./reset.sh  # Full clean reinstall
```

### Tavily Search Not Working

**Symptoms:** No industry research or salary data in reports

**Solutions:**
- Verify `TAVILY_API_KEY` is set correctly in `.env`
- Check you haven't exceeded free tier limits (1,000 searches/month)
- Monitor execution trace panel in UI for Tavily-specific errors

**Note:** The app works without Tavily but won't include industry research in reports.

### Virtual Environment Issues

If you see `(.venv)` in your prompt but commands fail:

```bash
deactivate
./reset.sh
source .venv/bin/activate
make run
```

Or simply open a new terminal window:
```bash
cd datacamp-mcp-multiagent-demo
source .venv/bin/activate
make run
```

---

## 🎯 Future Enhancements

**Planned features:**

- **Vector & Hybrid Search** → MongoDB Atlas Vector Search for semantic project/mentor matching
- **File Uploads** → Resume and job description parsing
- **Embeddings & Reranking** → Voyage AI integration for improved search quality
- **PDF Export** → Professional promotion packet documents
- **Team Collaboration** → Multi-user review and comment features
- **Advanced Mentor Filtering** → Search by company, location, seniority level
- **Monitoring & Observability** → LLM cost tracking, latency metrics, quality dashboards
- **Model Flexibility** → Support for additional LLM providers and local models

---

## 📺 Demo & Tutorial

This project was created for the **DataCamp Multi-Agent Systems Webinar**.

**Key topics covered:**
- Building multi-agent systems with LangGraph
- Persistent memory with MongoDB Atlas
- Human-in-the-loop AI workflows
- MCP integration for real-time data enrichment
- Production deployment patterns

---

## 🤝 Contributing

Issues and pull requests are welcome! For major changes, please open an issue first to discuss what you'd like to change.

**Development workflow:**
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Run linters: `make format && make lint`
5. Commit your changes (`git commit -m 'Add amazing feature'`)
6. Push to the branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

---

## 📄 License

MIT License - see LICENSE file for details

---

## 🌟 Explore More

**Interested in building production-grade AI applications with MongoDB?**

👉 **[MongoDB AI Applications Hub](https://github.com/mongodb-developer/GenAI-Showcase)**  
👉 **[LangChain + MongoDB Integration](https://www.mongodb.com/docs/atlas/ai-integrations/langchain/)**  
👉 **[MongoDB Developer Center](https://www.mongodb.com/resources/use-cases/artificial-intelligence)**

**Related Projects:**
- [LangGraph Documentation](https://pypi.org/project/langgraph-checkpoint-mongodb/)
- [Gradio Documentation](https://www.gradio.app/docs/)
- [Model Context Protocol (MCP)](https://modelcontextprotocol.io/)

---

**Happy building!** If you create something cool with this project, share it with us or open a PR to showcase your work.

---

## 📞 Support

- **Issues:** [GitHub Issues](https://github.com/mikikob-mongodb/datacamp-mcp-multiagent-demo/issues)
- **Discussions:** [GitHub Discussions](https://github.com/mikikob-mongodb/datacamp-mcp-multiagent-demo/discussions)
- **MongoDB Community:** [MongoDB Community Forums](https://www.mongodb.com/community/forums/)