# Workspace for developing [k8s applications](https://github.com/kubernetes-sigs/application)


## Dependencies:
- install [kwt](https://github.com/k14s/kwt) for example via [k14s.io](https://k14s.io/)

## Usage:
```
kwt workspace create \
    --workspace w-$(echo "$(whoami)$(pwd)" | shasum | cut -c1-5) \
    --image starkandwayne/k8s-apps-workspace:latest \
    --image-command-arg --mtu=1400 \
    --input workspace=.:/root/workspace \
    --privileged \
    --watch \
    --enter \
    --rm
```

To figure out the right `mtu` value run:
```
apk add iputils && tracepath google.com | grep -i localhost
```
