# MCP-LLM Bridge

A TypeScript implementation that connects local LLMs (via Ollama) to Model Context Protocol (MCP) servers. This bridge allows open-source models to use the same tools and capabilities as Claude, enabling powerful local AI assistants.

## Overview

This project bridges local Large Language Models with MCP servers that provide various capabilities like:
- Filesystem operations
- Brave web search
- GitHub interactions
- Google Drive & Gmail integration
- Memory/storage
- Image generation with Flux

The bridge translates between the LLM's outputs and the MCP's JSON-RPC protocol, allowing any Ollama-compatible model to use these tools just like Claude does.

## Architecture

- **Bridge**: Core component that manages tool registration and execution
- **LLM Client**: Handles Ollama interactions and formats tool calls
- **MCP Client**: Manages MCP server connections and JSON-RPC communication
- **Tool Router**: Routes requests to appropriate MCP based on tool type

### Container Components
- **Ollama**: Runs the LLM (qwen2.5-coder:7b-instruct)
- **Open WebUI**: Web interface for Ollama
- **MCP Bridge**: The bridge service connecting LLMs to MCP tools

### Key Features
- Multi-MCP support with dynamic tool routing
- Structured output validation for tool calls
- Automatic tool detection from user prompts
- Robust process management for Ollama
- Detailed logging and error handling
- Fully containerized setup for easy deployment

## Docker Setup

1. Make sure you have Docker and Docker Compose installed on your system.

2. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/ollama-mcp-bridge.git
   cd ollama-mcp-bridge
    ```
3. Configure credentials in .env file (copy from .env.template):
    ```bash
    cp .env.template .env
    ```
4. Start the containers using the provided script:
    ```bash
    chmod +x start.sh
    ./start.sh
    ```

### This script will:

  Check if Docker is installed and running
  Build and start all containers
  Pull the qwen2.5-coder:7b-instruct model
  Open a shell in the MCP Bridge container

5. To stop the containers:
    ```bash
    ./stop.sh
    ```

## Accessing the Services

After starting the containers, you can access:

- Ollama API: http://localhost:7869
- Open WebUI: http://localhost:8080
- MCP Bridge: http://localhost:3000

## Container Configuration

The setup uses Docker Compose with the following containers:

1. **Ollama**: Runs the LLM
   - Image: `ollama/ollama:latest`
   - Port: 7869:11434
   - Volume: `./ollama/ollama:/root/.ollama`

2. **Ollama WebUI**: Web interface
   - Image: `ghcr.io/open-webui/open-webui:main`
   - Port: 8080:8080
   - Volume: `./ollama/ollama-webui:/app/backend/data`

3. **MCP Bridge**: Bridge service
   - Built from local Dockerfile
   - Port: 3000:3000
   - Volume: `./bridge_workspace:/app/workspace`

The configuration is defined in `docker-compose.yml`.

## Usage (Inside MCP Bridge Container)

When the start script completes, you'll be in a shell inside the MCP Bridge container where you can:
- trigger an "npm run start" command to start the bridge
- Use `list-tools` to show available tools
- Enter prompts to interact with the LLM
- Type `quit` to exit the program

## Example interactions:

- Search the web for "latest TypeScript features" [Uses Brave Search MCP to find results] 

- Create a new folder called "project-docs" [Uses Filesystem MCP to create directory]

## Available MCP Tools

The containerized setup provides:
- Filesystem operations
- Brave web search (requires API key)
- GitHub interactions (requires API token)
- Memory/storage
- Image generation with Flux (requires API token)
- Gmail & Drive integration (requires OAuth setup)

## Configuration

The bridge is configured through `bridge_config.json`:
- MCP server definitions
- LLM settings
- Tool permissions and paths
