resource "null_resource" "gitlab-agent_service" {
  provisioner "local-exec" {
    command = "helm repo add gitlab https://charts.gitlab.io && helm repo update && helm upgrade --install diplom gitlab/gitlab-agent --namespace gitlab-agent-diplom --create-namespace --set image.tag=v16.11.3 --set config.token=glagent-4VYsKy_fMv3WR33Njz6oENE8YVXd53Ek5YehRr-YdnXCFnYaVg --set config.kasAddress=wss://lunezhev2.gitlab.yandexcloud.net/-/kubernetes-agent/"
  }
  depends_on = [
    null_resource.grafana_service
  ]
}