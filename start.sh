#!/bin/bash

if ! command -v docker &> /dev/null
then
    echo "Docker não está instalado. Instalando Docker..."
    sudo apt-get update
    sudo apt-get install -y docker.io
fi
if ! systemctl is-active --quiet docker
then
    echo "Docker não está em execução. Iniciando Docker..."
    sudo systemctl start docker
fi
if ! systemctl is-active --quiet docker
then
    echo "Docker não está ativo. Verifique a instalação do Docker."
    exit 1
fi

echo "Construindo e iniciando containers..."
docker compose up -d --build

echo "Instalando modelo qwen2.5-coder:7b-instruct no Ollama..."
sleep 10
docker exec ollama ollama pull qwen2.5-coder:7b-instruct

echo "Ambiente Docker iniciado!"
echo "- Ollama API disponível em: http://localhost:7869"
echo "- Open WebUI disponível em: http://localhost:8080"
echo "- MCP Bridge disponível em: http://localhost:3000"

docker exec -it mcp-bridge bash