function kubectl_get_current_context
  kubectl config set-context --current --namespace="$argv[1]"
end
