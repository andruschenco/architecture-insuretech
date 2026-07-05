#!/bin/bash

echo "=== 1. Сборка образа ==="
docker build -t test-app-metrics .

echo "=== 2. Загрузка образа в Minikube ==="
minikube image load test-app-metrics

echo "=== 3. Удаление старого deployment ==="
kubectl delete deployment test-app 2>/dev/null

echo "=== 4. Применение deployment ==="
kubectl apply -f deployment.yaml

echo "=== 5. Ожидание запуска ==="
kubectl wait --for=condition=ready pod -l app=test-app --timeout=60s

echo "=== 6. Проверка статуса ==="
kubectl get pods
kubectl get svc

echo "=== 7. Получение URL ==="
URL=$(minikube service test-app-service --url)
echo "URL: $URL"

echo "=== 8. Проверка главной страницы ==="
curl $URL

echo ""
echo "=== 9. Проверка метрик ==="
curl $URL/metrics

echo ""
echo "✅ Готово!"