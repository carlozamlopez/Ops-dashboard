# ROADMAP — OPS Dashboard

## Fase 0 — Base del proyecto
- [x] README
- [ ] Estructura de carpetas
- [ ] .gitignore
- [ ] Documentación: HLD, HADR, FINOPS, ADR

## Fase 1 — Docker local
- [ ] Dockerfile frontend
- [ ] Dockerfile API
- [ ] Docker Compose completo
- [ ] Verificar comunicación frontend → API → MySQL

## Fase 2 — Terraform infra
- [ ] Módulo networking
- [ ] Módulo MySQL + Private Endpoint
- [ ] Módulo AKS
- [ ] Módulo App Gateway + AGIC
- [ ] Módulo Key Vault

## Fase 3 — Kubernetes
- [ ] Namespaces
- [ ] Deployments base
- [ ] Services
- [ ] Ingress AGIC
- [ ] PodDisruptionBudget (HADR)
- [ ] Kustomize overlays dev/staging/prod

## Fase 4 — CI/CD GitHub Actions
- [ ] Pipeline CI (lint + build + push ACR)
- [ ] Pipeline CD dev (automático)
- [ ] Pipeline CD staging (automático)
- [ ] Pipeline CD prod (aprobación manual)

## Fase 5 — App Gateway + AGIC
- [ ] Verificar routing / → frontend
- [ ] Verificar routing /api/* → API
- [ ] Acceder desde browser

## Fase 6 — Frontend visual
- [ ] Dashboard con métricas
- [ ] Gráficas con Chart.js
- [ ] Consumir API real

## Fase 7 — Monitoreo y cierre
- [ ] Log Analytics conectado a AKS
- [ ] Alertas básicas
- [ ] LLD final
- [ ] terraform destroy ordenado