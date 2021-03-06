apiVersion: apps/v1
kind: Deployment
metadata:
  name: etcd
  namespace: kube-system
spec:
  selector:
    matchLabels:
      app: etcd
  replicas: 1
  template:
    metadata:
      labels:
        app: etcd
    spec:
      nodeSelector:
        cc: deploy
      imagePullSecrets:
      - name: _HARBOR_SECRET_NAME_
      hostNetwork: true
      containers:
      - name: etcd
        image: _HARBOR_IMAGE_ADDR_/etcd:v3.3.18
        imagePullPolicy: IfNotPresent
        command: ["/usr/local/bin/etcd"]
        args:
        - "--name=etcd"
        - "--data-dir=/etcd-data/"
        - "--listen-peer-urls=http://0.0.0.0:9380"
        - "--initial-advertise-peer-urls=http://_ETCD_HOST_IP_:9380"
        - "--listen-client-urls=http://0.0.0.0:9379"
        - "--advertise-client-urls=http://_ETCD_HOST_IP_:9379"
        - "--initial-cluster-token=etcd-cluster-token"
        - "--initial-cluster-state=new"
        - "--log-output=stdout"
        volumeMounts:
        - name: etcd-data
          mountPath: /etcd-data/
        ports:
        - containerPort: 9379
      volumes:
      - name: etcd-data
        hostPath:
          path: /home/work/ote/etcd-data/
---

apiVersion: v1
kind: Service
metadata:
  name: etcd
  namespace: kube-system
spec:
  selector:
    app: etcd
  type: ClusterIP
  ports:
  - port: 9379
    targetPort: 9379
