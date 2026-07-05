### Описание ключевых решений

#### 1. **Event-Driven обновление кэша продуктов**

```
Страховая компания
       │
       ▼
ins-product-aggregator
       │
       ▼
Событие "ProductUpdated"
       │
       ▼
     Kafka
       │
       ▼
core-app (подписчик) → обновление кэша
ins-comp-settlement (подписчик) → обновление кэша
```

**Преимущества:**
- Асинхронное обновление данных
- Мгновенная инвалидация кэша при изменении продуктов
- Все сервисы имеют актуальные данные

#### 2. **Transactional Outbox**

```sql
-- Таблица outbox в PostgreSQL
CREATE TABLE outbox (
    id UUID PRIMARY KEY,
    aggregate_type VARCHAR(100),
    aggregate_id UUID,
    event_type VARCHAR(100),
    payload JSONB,
    created_at TIMESTAMP,
    processed BOOLEAN DEFAULT FALSE
);
```

**Когда использовать:**
- При оформлении страховки (событие `PolicyCreated`)
- При изменении статуса страховки (`PolicyUpdated`)
- При изменении клиентских данных (`ClientUpdated`)

**Преимущества:**
- Гарантированная доставка событий
- Атомарность с транзакцией базы данных
- Возможность повторной отправки при сбоях

#### 3. **CQRS (Command Query Responsibility Segregation)**

| Сервис                     | Command (запись)                             | Query (чтение)                          |
|----------------------------|----------------------------------------------|-----------------------------------------|
| **core-app**               | Пишет команды в Kafka (оформление страховок) | Читает из локального кэша продуктов     |
| **ins-product-aggregator** | Получает события от страховых компаний       | Не используется (только запись)         |
| **ins-comp-settlement**    | Получает события о страховках                | Читает из кэша для формирования реестра |

#### 4. **Очереди сообщений (Kafka)**

| Топик             | Производитель          | Потребители                             | Назначение                   |
|-------------------|------------------------|-----------------------------------------|------------------------------|
| `product-updated` | ins-product-aggregator | core-app, ins-comp-settlement           | Обновление продуктов         |
| `policy-created`  | core-app               | ins-comp-settlement, страховая компания | Оформление страховки         |
| `policy-updated`  | core-app               | ins-comp-settlement                     | Изменение статуса            |
| `client-updated`  | client-info            | core-app                                | Обновление клиентских данных |

#### 5. **Rate Limiter для B2B**

- На уровне API Gateway
- Ограничение 20 RPS для каждого партнера
- При превышении — возврат HTTP 429 (Too Many Requests)

#### 6. **Health Checks для отказоустойчивости**

- Добавлены **liveness** и **readiness** probes для всех сервисов
- API Gateway проверяет доступность core-app перед маршрутизацией
- core-app проверяет доступность client-info и aggregator
- При недоступности сервиса трафик не направляется на него
- Обеспечивает соответствие требованиям RTO 45 минут и RPO 15 минут
