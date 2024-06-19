// provisioning kube-prometheus 
resource "null_resource" "monitoring_deployment" {
  provisioner "local-exec" {
    command = "helm repo add prometheus-community https://prometheus-community.github.io/helm-charts && helm repo update && helm install prometheus-stack  prometheus-community/kube-prometheus-stack --namespace monitoring --create-namespace"
  }
  depends_on = [
    null_resource.kubeconfig_cp
  ]
}

resource "null_resource" "grafana_service" {
  provisioner "local-exec" {
    command = "kubectl apply -f ./monitoring/grafana.yaml"
  }
  depends_on = [
    null_resource.monitoring_deployment
  ]
}