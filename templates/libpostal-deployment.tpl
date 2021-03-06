apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: pelias-libpostal
spec:
  replicas: {{ .Values.libpostalReplicas | default 1 }}
  strategy:
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
  template:
    metadata:
      labels:
        app: pelias-libpostal
    spec:
      containers:
        - name: pelias-libpostal
          image: pelias/libpostal-service:{{ .Values.libpostalDockerTag | default "latest" }}
          resources:
            limits:
              memory: 3Gi
              cpu: 1.5
            requests:
              memory: 2Gi
              cpu: 0.1
          livenessProbe:
            httpGet:
              path: /parse?address=readiness
              port: 4400
          readinessProbe:
            httpGet:
              path: /parse?address=readiness
              port: 4400
