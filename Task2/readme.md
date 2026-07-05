# Задание 2. Динамическое масштабирование контейнеров

---

## Состав директории Task2

### Файлы
| Файл                                            | Содержание                                                                  |
|-------------------------------------------------|-----------------------------------------------------------------------------|
| **deployment.yaml**                             | Deployment приложения с образом `scaletestapp`                              |
| **service.yaml**                                | Service типа NodePort для доступа к приложению                              |
| **hpa-memory.yaml**                             | HPA по памяти (80% utilization) _понижал порог для демонстрации_            |
| **hpa-rps.yaml**                                | HPA по RPS (метрика `http_requests_per_second`)                             |
| **service-monitor.yaml**                        | ServiceMonitor для Prometheus                                               |
| **locustfile.py**                               | Сценарий нагрузочного тестирования                                          |
| **adapter-values.yaml**                         | Конфигурация Prometheus Adapter                                             |
| **readme.md**                                   | Документация по выполнению задания                                          |
| **readme-task1.md**                             | Результаты по Части 1 (HPA по памяти)                                       |
| **readme-task2.md**                             | Результаты по Части 2 (HPA по RPS)                                          |
| **img/dashboard.png**                           | Дашборд Kubernetes (поды, деплойменты)                                      |
| **img/Изменение_нагрузки_в_locust.png**         | Графики Locust (RPS, Users) при воспроизведении нагрузки в рамках Задания 2 |
| **img/Значение_метрики_(RPS)_в_Prometheus.png** | Prometheus Graph (метрика RPS)                                              |
---

---

## Часть 1. Динамическая маршрутизация на основании показателей утилизации памяти
[readme-task1.md](readme-task1.md)

## Часть 2. Динамическая маршрутизация на основании метрики RPS 
[readme-task2.md](readme-task2.md)

