# Задание 4. Проектирование продажи ОСАГО. 

## Основные решения
### 1. osago-aggregator
- **Хранилище**: PostgreSQL / Redis для хранения состояний заявок
- **API для core-app**: REST (POST /api/osago/apply)
- **Интеграция**: REST + Kafka (асинхронная обработка)
- **Масштабирование**: Горизонтальное (несколько реплик)

### 2. Интеграция веб-приложения
- **Средство**: WebSocket / SSE
- **Причина**: Потоковая передача предложений по мере поступления

### 3. Паттерны отказоустойчивости
- **Rate Limiting**: API Gateway (20 RPS для B2B)
- **Circuit Breaker**: core-app → osago-aggregator, osago-aggregator → страховые компании
- **Retry**: osago-aggregator → страховые компании
- **Timeout**: osago-aggregator → страхов

## Содержание
- [Диаграмма архитектуры](2-To-be-osago-diagram.drawio)
- [Ключевые архитектурные решения](key-decisions.md)
