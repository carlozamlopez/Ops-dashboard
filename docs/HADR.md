# HADR — High Availability & Disaster Recovery
## OPS Dashboard · Azure Microservices Platform
**Versión:** 1.0
**Autor:** Carlos Amador López (Azure Infra Architect)
**Fecha:** 2026-03-18

## 1. Definiciones

| Término | Definición |
|---------|------------|
| RTO | Tiempo de Recuperacion de operación  |
| RPO | Tiempo de perdida de datos |
| HA | Alta Disponibilidad |
| DR | Plan de Recuperación de Desastre|

## 2. Matriz de SLA por ambiente

| Parámetro | DEV      | STAGING  | PROD          |
|-----------|----------|----------|---------------|
| SLA       | 99%      | 99.5%    | 99.9%         |
| RTO       | 4 horas  | 2 horas  | 1 hora        |
| RPO       | 24 horas | 4 horas  | 15 minutos    |
| Penalización | -     | -        | $10,000 USD   |

## 3. Estrategia HA por componente

### AKS
3 nodos en prod distribuidos en 3 Availability Zones dentro de eastus.
Si una zona falla, los pods se redistribuyen en las otras dos automáticamente.
Dev: 1 nodo. Staging: 2 nodos en 2 zonas.

### MySQL
Prod: Zone Redundant HA — servidor primario en Zona 1, standby en Zona 2.
Replicación síncrona. Failover automático en ~60 segundos si falla la zona primaria.
Dev y Staging: sin HA — backup automático diario de 7 días es suficiente.

### Application Gateway
Standard_v2 y WAF_v2 escalan automáticamente entre múltiples instancias.
SLA de 99.95% — el componente más resiliente de la arquitectura.

## 4. Estrategia DR

### Región primaria y secundaria
Primaria: eastus | Secundaria: westus

### MySQL DR
Read Replica en westus con replicación continua desde el primario.
RPO real: ~5 minutos (lag de replicación).
En caso de DR: promover la replica a servidor independiente con un comando.
Solo geo-backup no es suficiente — RPO de hasta 24 horas, inaceptable para prod.

### AKS DR
Toda la infra está en Terraform — se recrea en westus en ~30-45 minutos.
Imágenes Docker en ACR con geo-replication a westus.
RTO total del sistema: ~45-60 minutos. Cumple el SLA de 1 hora.

## 5. Runbook DR — Paso a paso
1. Confirmar incidente en status.azure.com y abrir ticket con Microsoft
2. Notificar al cliente: "Activando DR, ETA 60 minutos"
3. Promover MySQL Read Replica en westus a servidor primario
4. Ejecutar terraform apply en región westus para recrear AKS
5. Verificar pods y health checks — notificar restauración al cliente

## 6. Testing del plan DR

| Prueba | Frecuencia | Responsable |
|--------|-----------|-------------|
| Failover MySQL HA (zona) | Trimestral | Arch |
| Restore desde geo-backup | Semestral | DevOps |
| Simulacro DR completo | Anual | Todo el equipo |