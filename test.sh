#!/bin/bash

# Faz a primeira requisição em background
curl -o /dev/null http://localhost:3001/headquarter & curl -o /dev/null http://localhost:3001/service & wait

# Aguarda as requisições terminarem
wait

# Exibe uma mensagem quando as requisições foram concluídas
echo "As requisições foram concluídas."
