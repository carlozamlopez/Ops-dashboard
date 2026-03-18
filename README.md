# OPS Dashboard — Azure Microservices Platform

Dashboard de métricas operacionales con arquitectura enterprise en Azure.

## Equipo
| Rol | Responsabilidad |
|-----|----------------|
| Arch / Infra Azure | Terraform, AKS, App Gateway, MySQL, Key Vault |
| DevOps 1 | CI/CD, Docker, ACR |
| DevOps 2 | Kubernetes, Kustomize, monitoreo |

## Stack
- **App:** Python Flask (frontend + API)
- **Base de datos:** Azure MySQL Flexible Server + Private Endpoint
- **Orquestación:** AKS + Application Gateway (AGIC)
- **IaC:** Terraform modular
- **CI/CD:** GitHub Actions