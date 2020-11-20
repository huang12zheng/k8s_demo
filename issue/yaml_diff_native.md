# tcloud 上的yaml与原生的yaml存在差异

## example

* steps
1. create yaml about a pod,which like
```
apiVersion: batch/v1
kind: Job
metadata:
  name: echo-value
spec:
  template:
    spec:
      containers:
      - name: echo-value
        image: busybox
        command: ["echo",  "echo success"]
      restartPolicy: Never
  backoffLimit: 4
```
2. Create pod.
```
kubectl apply -f job.ym
```
```
job.batch/echo-value created
```
3. 