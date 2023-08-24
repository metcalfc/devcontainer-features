# Dagger CLI (dagger)

A feature to install the Dagger CLI

## Example Usage

```json
"features": {
    "ghcr.io/metcalfc/dagger-devcontainer-features/dagger:v0.8.4": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| version | The version of Dagger to install | string | v0.8.4 |
| location | The location for the Dagger binary | string | /usr/local/bin |
| completion | Whether or not to install the Dagger shell completions | boolean | false |

---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/metcalfc/dagger-devcontainer-feature/blob/main/src/dagger/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._

