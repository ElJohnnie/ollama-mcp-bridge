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

echo "Aguardando containers iniciarem..."
sleep 10

echo "Verificando se há containers em execução..."
running_containers=$(docker ps -q)
if [ -z "$running_containers" ]; then
    echo "Nenhum container em execução. Verifique os logs para mais detalhes."
    docker compose logs
    exit 1
fi
echo "Containers em execução: $running_containers"

echo "Instalando modelo qwen2.5-coder:7b-instruct no Ollama..."
sleep 10
docker exec ollama ollama pull qwen2.5-coder:7b-instruct

echo "Verificando se o modelo foi instalado..."
model_status=$(docker exec ollama ollama list | grep "qwen2.5-coder:7b-instruct")
if [ -z "$model_status" ]; then
    echo "Modelo não instalado. Verifique os logs para mais detalhes."
    docker exec ollama ollama list
    exit 1
fi
echo "Modelo qwen2.5-coder:7b-instruct instalado com sucesso!"

echo "Ambiente Docker iniciado!"
echo "- Ollama API disponível em: http://localhost:7869"
echo "- Open WebUI disponível em: http://localhost:8080"
echo "- MCP Bridge disponível em: http://localhost:3000"

docker exec -it mcp-bridge bash

echo "Acessando o container MCP Bridge..."
