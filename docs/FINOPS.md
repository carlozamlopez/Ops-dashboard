# FINOPS — Gestión y Optimización de Costos
## OPS Dashboard · Azure Microservices Platform
**Versión:** 1.0
**Autor:** Carlos Amador López (Azure Infra Architect)
**Fecha:** 2026-03-18
**Audiencia:** CTO, Project Manager, Cliente

## 1. Resumen Ejecutivo

| Ambiente | Costo/mes | Costo anual |
|----------|-----------|-------------|
| DEV      | $182 USD  | $2,184 USD  |
| STAGING  | $382 USD  | $4,584 USD  |
| PROD     | $891 USD  | $10,692 USD |
| **TOTAL**| **$1,455 USD** | **$17,460 USD** |

## 2. Desglose por ambiente

### DEV — $182 USD/mes
| Servicio | SKU | Justificación | Costo/mes |
|---------|-----|--------------|-----------|
| AKS Node Pool | 1x Standard_DC2s_v3 | 1 nodo suficiente, sin HA en dev | $70 |
| MySQL Flexible | B_Standard_B1ms | Burstable: cargas variables de dev | $15 |
| Application Gateway | Standard_v2 | Requerido para AGIC, sin WAF en dev | $45 |
| ACR | Basic | Solo almacenamiento de imágenes | $5 |
| Key Vault | Standard | Operaciones mínimas | $2 |
| Log Analytics | ~2GB/mes | 30 días retención | $5 |
| Storage, Red | — | Backend Terraform, VNet, NSGs | $7 |
| Buffer 20% | | Variaciones de uso | $33 |
| **TOTAL DEV** | | | **$182** |

### STAGING — $382 USD/mes
| Servicio | SKU | Justificación | Costo/mes |
|---------|-----|--------------|-----------|
| AKS Node Pool | 2x Standard_DC2s_v3 | 2 nodos en 2 zonas — simula prod | $140 |
| MySQL Flexible | GP_Standard_D2ds | General Purpose: performance predecible | $85 |
| Application Gateway | Standard_v2 | Misma arquitectura que prod | $60 |
| ACR | Standard | Mismas imágenes que prod | $20 |
| Log Analytics | ~5GB/mes | Más logs que dev | $12 |
| Otros | — | Key Vault, Red, IPs | $13 |
| Buffer 20% | | | $52 |
| **TOTAL STAGING** | | | **$382** |

### PROD — $891 USD/mes
| Servicio | SKU | Justificación WAF | Costo/mes |
|---------|-----|------------------|-----------|
| AKS Node Pool | 3x Standard_D4s_v3 | **Reliability:** 3 zonas, tolerancia a falla | $210 |
| MySQL Primario | GP D4ds + Zone HA | **Reliability:** failover automático ~60s | $220 |
| MySQL Read Replica | GP D4ds (westus) | **Reliability:** RPO 5 min, cumple SLA $10K | $150 |
| App Gateway | WAF_v2 | **Security:** OWASP 3.2 activo en prod | $120 |
| ACR Premium | + geo-replication | **Reliability:** imágenes en región DR | $50 |
| Log Analytics | ~20GB/mes | **Operational Excellence:** 90 días retención | $50 |
| Otros | — | Key Vault, IPs, Red | $50 |
| Buffer 5% | | Prod tiene menos variación | $41 |
| **TOTAL PROD** | | | **$891** |

## 3. Estrategia de Optimización FinOps

### 3.1 Reserved Instances — Mayor ahorro disponible
Después de 2 meses de uso real, comprar Reserved Instance de 1 año:

| Recurso | Pay-as-you-go | Reserved 1 año | Ahorro |
|---------|--------------|----------------|--------|
| 3x D4s_v3 (AKS prod) | $210/mes | ~$126/mes | 40% |
| MySQL GP D4ds (primario) | $220/mes | ~$145/mes | 34% |
| **Ahorro total** | | | **$159/mes = $1,908/año** |

> Recomendación: No comprar en los primeros 2 meses.
> Primero validar SKU correcto con datos reales de Azure Advisor.

### 3.2 Auto-shutdown en DEV
Apagar nodos AKS fuera de horario laboral:
- Horario activo: Lunes-Viernes 08:00-20:00
- Ahorro estimado: 60% del costo de nodos DEV
- Implementación: node pool scaling via Terraform

### 3.3 Tags obligatorios via Azure Policy
Sin tags no hay chargeback. Todos los recursos deben tener:

| Tag | Valor ejemplo |
|-----|--------------|
| proyecto | ops-dashboard |
| ambiente | dev / staging / prod |
| owner | arch-carlozamlopez |
| cost-center | KOF-DIGITAL-001 |
| managed_by | terraform |

### 3.4 Presupuestos con alertas

| Ambiente | Presupuesto | Alerta 70% | Alerta 90% | Alerta 100% |
|----------|------------|-----------|-----------|-------------|
| DEV | $220 USD | email | email+Slack | email+Slack |
| STAGING | $460 USD | email | email+Slack | email+Slack |
| PROD | $1,100 USD | email | email+Slack | PagerDuty crítico |

### 3.5 Proyección con optimizaciones

| Mes | DEV | STAGING | PROD | TOTAL |
|-----|-----|---------|------|-------|
| 1-3 | $182 | $382 | $891 | $1,455 |
| 4+ (auto-shutdown dev) | $140 | $382 | $891 | $1,413 |
| 4+ (Reserved Instances prod) | $140 | $382 | $732 | $1,254 |
| **Ahorro anual total** | | | | **$2,412 USD** |

## 4. Resumen ejecutivo para el cliente

**Inversión total año 1:** ~$17,460 USD

**Lo que incluye:**
- 3 ambientes independientes con aislamiento completo
- HA en prod: SLA 99.9%, RTO 1 hora, RPO 15 minutos
- Seguridad enterprise: WAF, Zero Trust, cifrado, auditoría
- CI/CD automatizado con aprobación manual en producción
- Monitoreo 24/7 con alertas automáticas

**Próximos pasos para reducir costos:**
1. Mes 2: Auto-shutdown DEV → -$42/mes
2. Mes 3: Reserved Instances prod → -$159/mes
3. Mes 6: Right-sizing con Azure Advisor