---
https://console.cloud.tencent.com/workorder/detail?ticketId=202011205076
【问题描述】更新子账号的 TKE 集群访问凭证时找不到，Kubeconfig权限管理，协助看下
【相关信息】https://cloud.tencent.com/document/product/457/46108 

----
这个功能要开白，我给你开一下, 每个集群都要  (最左)
----

Modify kubeconfig files using subcommands like "kubectl config set current-context my-context"

 The loading order follows these rules:

  1.  If the --kubeconfig flag is set, then only that file is loaded. The flag may only be set once and no merging takes place.
  2.  If $KUBECONFIG environment variable is set, then it is used as a list of paths (normal path delimiting rules for your system). These paths are merged. When a value is modified, it is modified in the file that defines the stanza. When a value is created, it is created in the first file that exists. If no files in the chain exist, then it creates the last file in the list.
  3.  Otherwise, ${HOME}/.kube/config is used and no merging takes place.

Available Commands:
  current-context Displays the current-context
  delete-cluster  Delete the specified cluster from the kubeconfig
  delete-context  Delete the specified context from the kubeconfig
  get-clusters    Display clusters defined in the kubeconfig
  get-contexts    Describe one or many contexts
  rename-context  Renames a context from the kubeconfig file.
  set             Sets an individual value in a kubeconfig file
  set-cluster     Sets a cluster entry in kubeconfig
  set-context     Sets a context entry in kubeconfig
  set-credentials Sets a user entry in kubeconfig
  unset           Unsets an individual value in a kubeconfig file
  use-context     Sets the current-context in a kubeconfig file
  view            Display merged kubeconfig settings or a specified kubeconfig file

Usage:
  kubectl config SUBCOMMAND [options]

Use "kubectl <command> --help" for more information about a given command.
Use "kubectl options" for a list of global command-line options (applies to all commands).
------

https://cloud.tencent.com/document/product/457/48164#QA

登录 容器服务控制台。
获取当前使用账号的凭证信息 Kubeconfig 文件，请参见 获取凭证。
获取 Kubeconfig 文件后，可以选择开启内网访问，也可直接使用 Kubernetes 的 service IP。在集群详情页面中，选择左侧的【服务与路由】>【Service】获取 default 命名空间下 Kubernetes 的 service IP。将 Kubeconfig 文件中 clusters.cluster.server 字段替换为 https://<IP>:443 即可。
拷贝 Kubeconfig 文件内容到新节点上的 $HOME/.kube/config 下。
访问 Kubeconfig 集群，使用 kubectl get nodes 测试是否连通。


----



* issue1
```
$ kubectl get node
error: You must be logged in to the server (Unauthorized)
```

solution1:
https://cloud.tencent.com/document/product/457/48164

* issue2
follow by solution1, turn it to as follow
```
kubectl get node
Error from server (BadRequest): the server rejected our request for an unknown reason
```
ps: 
part of kubeconfig
```
clusters:
- cluster:
    # server: https://cls-a8apx2d7.ccs.tencent-cloud.com
    server: 172.16.252.1:443
```

* issue3:
What is mean about 
```
特殊场景
workload 已挂载 host 的 /root/.kube/config 或者 /home/ubuntu/.kube/config 文件进行使用。
```
Does it have anything to do with my issue2?



----
* case 1

1. switch_on_publish_access & switch_on_inner_access 
2. .kube/config set from TCouldManageControl

* case 2
1. switch_off_publish_access & switch_on_inner_access 
2. sudo sed -i '$a 172.17.0.12 cls-a8apx2d7.ccs.tencent-cloud.com' /etc/hosts

> If you don't have step two, you're going to make a mistake

```
Unable to connect to the server: dial tcp: lookup cls-a8apx2d7.ccs.tencent-cloud.com on 183.60.83.19:53: no such host
```

* case 3
1. switch_off_publish_access & switch_on_inner_access 
2. sudo sed -i '$a 172.16.252.1 cls-a8apx2d7.ccs.tencent-cloud.com' /etc/hosts

> If you don't have step two, you're going to make a mistake

* case 4


----
k config --kubeconfig="~/.kube/config" get-contexts 
> with `tab` to switch to 
k config --kubeconfig="/home/ubuntu/.kube/config" get-contexts
and it would show info, other than no thing