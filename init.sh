#!/bin/bash

set -e

echo "🔧 Обновляем apt..."
sudo apt update

echo "📦 Устанавливаем Git..."
sudo apt install -y git

echo "✅ Git установлен: $(git --version)"

echo "🧹 Удаляем старые версии Docker (если есть)..."
sudo apt remove -y docker docker-engine docker.io containerd runc || true

echo "📦 Устанавливаем зависимости..."
sudo apt install -y ca-certificates curl gnupg lsb-release

echo "🔐 Добавляем GPG-ключ Docker..."
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
    sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "➕ Добавляем репозиторий Docker..."
echo \
  "deb [arch=$(dpkg --print-architecture) \
  signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "📥 Устанавливаем Docker..."
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "✅ Docker установлен: $(docker --version)"

echo "🚀 Тестовый запуск hello-world контейнера..."
sudo docker run hello-world

echo "👤 Добавляем текущего пользователя (${USER}) в группу docker..."
sudo usermod -aG docker $USER

echo "⚠️ Готово! Перезайди в терминал или перезапусти сервер, чтобы использовать Docker без sudo."
