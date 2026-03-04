# VALKYRIE // CRYPTO INTEL
### Self-Hosted Crypto Intelligence Monitor — Zero API Cost

![Status](https://img.shields.io/badge/status-active-00ff88)
![Cost](https://img.shields.io/badge/AI%20cost-%240.00-00ff88)
![Models](https://img.shields.io/badge/model-qwen3--coder%3A30b-00c8ff)

A real-time cryptocurrency intelligence dashboard that runs **entirely on your own hardware**. No external AI APIs. No subscriptions. No data leaving your server.

Pulls live market data, classifies patterns, and runs three layers of AI analysis through a local Ollama instance — all from a single HTML file served by nginx.

---

## WHAT IT DOES

### Live Market Intelligence
- Monitors multiple trading pairs across multiple timeframes simultaneously
- Pulls price, EMA 20/50/200, RSI 14, ATR 14 from your Trading Forge API
- Classifies patterns: breakout, bull_flag, uptrend, range, breakdown, and more
- Color-coded cards: green (bullish), red (bearish), amber (neutral)
- Detects pattern changes in real time with ⚡ flash alert

### Three AI Analysis Layers (Local Ollama)
| Layer | Trigger | What It Does |
|-------|---------|--------------|
| Layer 1 — Snapshot | Every scan | Current state: pattern, EMA status, RSI read, volatility, summary |
| Layer 2 — Trend | Every scan | Momentum over last 10 scans, divergences, consecutive signals, bias |
| Layer 3 — Cross-Market | Pattern change only | Market regime, leaders, laggards, sector move probability |

### Persistent Scan Logging
- 50 scan entries per pair/timeframe stored in browser
- Full history table with pattern change events flagged
- Filterable by pair

### Zero Cost Architecture
```
Browser → nginx (HTTPS) → Trading Forge API (your server)
                        → Ollama (your GPU/CPU)
                        → Dashboard (your server)
```
Every AI inference call: $0.00

---

![initial_monitor_tab.png](images/Valkyrie-Crypto-Intel-Photos)

---
## QUICK START — DOCKER

### Requirements
- Docker + Docker Compose
- A running [Trading Forge](https://github.com/your/trading-forge) API instance
- Ollama with at least one model pulled

### 1 — Clone
```bash
git clone https://github.com/youruser/valkyrie-crypto-intel.git
cd valkyrie-crypto-intel
```

### 2 — Configure
```bash
cp docker/.env.example docker/.env
nano docker/.env
```

Set your values:
```env
TRADING_FORGE_URL=http://your-server:8000
OLLAMA_URL=http://your-server:11434
OLLAMA_MODEL=qwen3-coder:30b
NGINX_PORT=80
```

### 3 — Launch
```bash
cd docker
docker compose up -d
```

### 4 — Open
```
http://localhost/valkyrie/
```

That's it. Add pairs, hit START.

---

## MANUAL INSTALL (No Docker)

### Requirements
- nginx
- Trading Forge API running
- Ollama running with a model loaded

### 1 — Copy dashboard
```bash
mkdir -p /var/www/valkyrie
cp index.html /var/www/valkyrie/index.html
```

### 2 — Add nginx location block
Inside your server block:
```nginx
location /valkyrie {
    alias /var/www/valkyrie/;
    index index.html;
    try_files $uri $uri/ /valkyrie/index.html;
}

location /api/ {
    proxy_pass http://127.0.0.1:8000/;
    proxy_http_version 1.1;
    add_header 'Access-Control-Allow-Origin' '*' always;
    add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS' always;
    add_header 'Access-Control-Allow-Headers' 'Content-Type' always;
}

location /ollama/ {
    proxy_pass http://127.0.0.1:11434/;
    proxy_http_version 1.1;
    add_header 'Access-Control-Allow-Origin' '*' always;
    add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS' always;
    add_header 'Access-Control-Allow-Headers' 'Content-Type' always;
}
```

### 3 — Reload nginx
```bash
nginx -t && systemctl reload nginx
```

---

## CONFIGURATION

All config is done in the dashboard UI — no file editing required after deploy.

| Field | Default | Description |
|-------|---------|-------------|
| Trading Forge API | your server | Base URL for market data |
| Ollama Endpoint | your server | Local AI inference endpoint |
| Ollama Model | qwen3-coder:30b | Primary analysis model |
| Interval | 10 min | Scan cycle frequency |
| Fallback Model | qwen2.5:7b | Used if primary is slow |

---

## SUPPORTED MODELS (Ollama)

| Model | Size | Speed | Quality |
|-------|------|-------|---------|
| qwen3-coder:30b | 18GB | 15-25s | ⭐⭐⭐⭐⭐ Recommended |
| qwen2.5:7b | 4.7GB | 5-10s | ⭐⭐⭐⭐ Fast fallback |
| llama3.2:3b | 2GB | 2-5s | ⭐⭐⭐ Lightweight |

Pull a model:
```bash
docker exec ollama ollama pull qwen3-coder:30b
```

---

## TRADING FORGE API ENDPOINTS USED

| Endpoint | Purpose |
|----------|---------|
| `/live_data?symbol=SOL/USDT&timeframe=1h&limit=300` | Price + all indicators |
| `/classify_pattern?symbol=SOL/USDT&timeframe=1h&limit=300` | Pattern label + confidence |
| `/quick_summary?symbol=SOL/USDT&timeframe=1h&limit=300` | Plain English overview |

All three fire in parallel on every scan cycle.

---

## ARCHITECTURE

```
┌─────────────────────────────────────────────┐
│              VALKYRIE DASHBOARD              │
│         (Single HTML — nginx served)         │
└──────────────┬──────────────────────────────┘
               │ HTTPS (every scan)
    ┌──────────┴──────────┐
    │                     │
    ▼                     ▼
Trading Forge API      Ollama API
(live_data,            (qwen3-coder:30b)
 classify_pattern,     Layer 1: Snapshot
 quick_summary)        Layer 2: Trend
                       Layer 3: Cross-Market
    │                     │
    └──────────┬──────────┘
               ▼
        Scan Log Storage
        (50 per pair/TF)
               │
               ▼
        Dashboard Cards
        + Cross-Market Tab
        + Scan Logs Tab
```

---

## ROADMAP

- [ ] Telegram/Discord webhook alerts on pattern change
- [ ] Price threshold alerts per pair
- [ ] Migrate scan logs to Trading Forge database
- [ ] Mobile-optimized layout
- [ ] Export scan history to CSV
- [ ] Multi-server Ollama load balancing

---

## LICENSE
MIT — use it, fork it, build on it.

---

*VALKYRIE COMMANDOPS — Truth over comfort. Execution over explanation.*
