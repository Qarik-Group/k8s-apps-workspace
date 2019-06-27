# Workspace for developing [k8s applications](https://github.com/kubernetes-sigs/application)


## Dependencies:
- install [kwt](https://github.com/k14s/kwt) for example via [k14s.io](https://k14s.io/)

## Usage:
Set your default namespace:
```
kubectl config set-context --current --namespace {namespace_name}
```

Give your workspace a name
```
export WORKSPACE=w-$(echo "$(whoami)$(pwd)" | shasum | cut -c1-5)
```

Create a service account for your workspace
```
kubectl create serviceaccount ${WORKSPACE}-sa
NS=$(kubectl config view --minify --output 'jsonpath={..namespace}')
kubectl create clusterrolebinding ${WORKSPACE}-crb \
    --clusterrole=cluster-admin --serviceaccount=${NS}:${WORKSPACE}-sa
```

Create your workspace:
```
kwt workspace create \
    --workspace ${WORKSPACE} \
    --image starkandwayne/k8s-apps-workspace:latest \
    --image-command-arg --mtu=1400 \
    --input workspace=.:/root/workspace \
    --service-account ${WORKSPACE}-sa \
    --privileged \
    --watch \
    --enter \
    --rm
```

To figure out the right `mtu` value run the following command from the workspace container:
```
apk add iputils && tracepath google.com | grep -i localhost
```
