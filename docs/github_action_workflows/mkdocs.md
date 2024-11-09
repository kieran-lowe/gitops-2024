# MkDocs (Material)

This workflow deploys the documentation using ["Material for Mkdocs"](https://squidfunk.github.io/mkdocs-material/) into GitHub Pages.

## Workflow

``` { .yaml title=".github/workflows/mkdocs.yml" linenums="1" } 
--8<-- ".github/workflows/mkdocs.yml"
```

## Configuration

This workflow triggers based on the `push` to the `main` branch, but only if any file within the `docs/` directory or `mkdocs.yml` is updated.

It also needs permission to publish to GitHub Actions, therefore we use the `contents: write` permission to grant it so. This deploys the documentation to a branch called `gh-pages` which the GitHub Pages configuration has been configured to listen too.

### Jobs

This workflow only has one job:

1. [deploy](#deploy)

#### deploy

``` { .yaml title=".github/workflows/mkdocs.yml" linenums="1" } 
deploy:
  runs-on: ubuntu-latest
  steps:
    - name: Check Out Code
      uses: actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683 # v4.2.2

    - name: Configure Git Credentials
      run: |
        git config user.name github-actions[bot]
        git config user.email 41898282+github-actions[bot]@users.noreply.github.com

    - name: Setup Python
      uses: actions/setup-python@0b93645e9fea7318ecaed2b359559ac225c90a2b # v5.3.0
      with:
        python-version: 3.x
    
    - name: Generate Cache ID
      run: echo "cache_id=$(date --utc '+%V')" >> $GITHUB_ENV
      shell: bash

    - uses: actions/cache@6849a6489940f00c2f30c0fb92c6274307ccb58a # v4.1.2
      with:
        key: mkdocs-material-${{ env.cache_id }}
        path: .cache
        restore-keys: |
          mkdocs-material-

    - name: Run Mkdocs Material
      run: pip install mkdocs-material

    - name: Deploy Mkdocs
      run: mkdocs gh-deploy --force
```

This job clones the repo and configures the latest Python 3 version available at runtime. This is because Material for Mkdocs is managed as a package using Python's package manager `pip`. A cache is then generated and `mkdocs-material` is installed. Lastly, it is deployed to the `gh-deploy` branch.
