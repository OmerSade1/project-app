resource "helm_release" "argocd" {
  depends_on = [ module.eks ]
  name             = "argocd"
  namespace        = "argocd"
  chart            = "argo-cd"
  repository       = "https://argoproj.github.io/argo-helm"
  version          = "7.7.11"
  create_namespace = true
set {
  name  = "server.ingress.enabled"
  value = "true"
}

set {
  name  = "server.ingress.ingressClassName"
  value = "nginx"
}

set {
  name  = "global.domain"
  value = "argocd.omsad.xyz"
}

set {
  name  = "server.ingress.path"
  value = "/"
}

set {
  name  = "server.ingress.pathType"
  value = "Prefix"
}
set {
  name = "configs.params.server\\.insecure"
  value = true
}

set {
  name  = "server.ingress.annotations"
  value = jsonencode({
    "kubernetes.io/ingress.class" = "nginx"
    })
  }
}   