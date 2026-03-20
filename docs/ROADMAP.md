# ROADMAP — OPS Dashboard

## ✅ FASE 0 — Base del proyecto (COMPLETADA)
- [x] README con roles del equipo
- [x] Estructura de carpetas enterprise
- [x] .gitignore (Terraform, Python, secretos)
- [x] HLD — Arquitectura de alto nivel
- [x] ADR-001 — App Gateway vs Load Balancer
- [x] HADR — HA, DR, RTO/RPO, Runbook
- [x] FINOPS — Presupuesto + optimización 12 meses
- [x] Todo en GitHub con flujo PR enterprise (9 PRs)
- [x] Branch main protegida con bypass Arch

## ✅ FASE 1 — Docker local (COMPLETADA)
- [x] Dockerfile frontend (multi-stage, non-root user)
- [x] Dockerfile API (multi-stage, non-root user)
- [x] Docker Compose completo con healthchecks
- [x] Flask API: /health, /api/metrics, /api/metrics/summary
- [x] Flask Frontend: dashboard visual + proxy a API
- [x] MySQL init.sql con schema y datos de prueba
- [x] Verificado: docker compose up funciona
- [x] Verificado: API health db:connected
- [x] Verificado: Dashboard mostrando métricas reales

## ✅ FASE 2 — Terraform infra (COMPLETADA)
- [x] Módulo networking: VNet, 4 subnets, NSGs, Log Analytics
- [x] Módulo ACR: Container Registry + AcrPull role
- [x] Módulo MySQL: Flexible Server + Private Endpoint opcional
- [x] Módulo AKS: Cluster + AGIC + zonas + monitoreo
- [x] Módulo AppGateway: App Gateway + WAF + lifecycle AGIC
- [x] Módulo KeyVault: RBAC + CSI Driver + secretos
- [x] Environment dev: orquestador completo
- [x] terraform plan: 28 recursos sin errores
- [x] terraform apply: exitoso en westus
- [x] terraform destroy: limpio
- [x] API con modo in-memory cuando no hay DB

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