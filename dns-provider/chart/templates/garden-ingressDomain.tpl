{{- define "garden.ingressDomain" -}}
{{- (print (first (lookup "operator.gardener.cloud/v1alpha1" "Garden" "" .Values.garden.name).spec.runtimeCluster.ingress.domains)) }}
{{- end -}}
