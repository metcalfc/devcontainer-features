# Devcontainer features for the Dagger CLI

If you are using devcontainer and you want to install the dagger CLI you can add:
```
    "features": {
      "ghcr.io/metcalfc/dagger-devcontainer-feature/dagger:v0.8.4": {}
    }
```

This feature is parameterized. You can specify the version to be installed, where
the binary is installed, and if shell completion should also be installed.

```
    "features": {
      "ghcr.io/metcalfc/dagger-devcontainer-feature/dagger:v0.8.4": {
        "completion": true,
        "location": "/usr/bin",
        "version": "v0.8.0"
      }
    }
```
