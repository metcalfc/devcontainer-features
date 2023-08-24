# Devcontainer features for the Dagger CLI

If you are using devcontainer and you want to install the dagger CLI you can add:
```
    "features": {
      "dagger": {}
    }
```

This feature is parameterized. You can specify the version to be installed, where
the binary is installed, and if shell completion should also be installed.

```
    "features": {
      "dagger": {
        "completion": true,
        "location": "/usr/bin",
        "version": "v0.8.0"
      }
    }
```
