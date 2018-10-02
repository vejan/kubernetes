apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: pelias-api
spec:
  replicas: {{ .Values.apiReplicas | default 1 }}
  minReadySeconds: 5 #kubernetes operates so fast it can be nice to slow things down a little
  strategy:
    rollingUpdate:
      maxSurge: 20
      maxUnavailable: 0
  template:
    metadata:
      labels:
        app: pelias-api
      annotations:
        bump: "1"
        checksum/config: {{ include (print $.Template.BasePath "/configmap.tpl") . | sha256sum }}
    spec:
      containers:
        - name: pelias-api
          image: pelias/api:{{ .Values.apiDockerTag | default "latest" }}
          volumeMounts:
            - name: config-volume
              mountPath: /etc/config
          env:
            - name: PELIAS_CONFIG
              value: "/etc/config/pelias.json"
            - name: NODE_ENV
              value: "production"
          resources:
            limits:
              memory: 0.5Gi
              cpu: 1.25
            requests:
              memory: 0.2Gi
              cpu: 0.49
      volumes:
        - name: config-volume
          configMap:
            name: pelias-json-configmap
            items:
              - key: pelias.json
                path: pelias.json
