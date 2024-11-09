# Terraform Docs

This workflow checks to ensure that `terraform-docs` has been ran in a specified directory. The aim is to check any changes made to the `tofu/` directory have been captured e.g. new resources, data sources, modules etc. This then helps consumers/developers understand quickly how the module itself behaves.

## Calling Workflow

``` { .yaml title=".github/workflows/pr.yml" linenums="49" } 
terraform-docs:
  uses: ./.github/workflows/terraform_docs.yml
  with:
    config_file: ".terraform-docs.yml"
    directory: "tofu"
    tfdoc_version: "v0.19.0"
```

## Workflow

``` { .yaml title=".github/workflows/terraform_docs.yml" linenums="1" } 
--8<-- ".github/workflows/terraform_docs.yml"
```

## Configuration

This Action was custom made by me, although there is an official GitHub Action available. Upon using it, I noticed the config file when passed in is completely ignored. Unfortunately it seems to be a bug as others have reported it as well: <https://github.com/terraform-docs/gh-actions/issues/136>.

### Jobs

#### check

``` { .yaml title=".github/workflows/pr.yml" linenums="22" } 
check:
  runs-on: ubuntu-latest
  steps:
    - name: Check Out Code
      uses: actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683 # v4.2.2

    - name: Install Terraform Docs
      run: |
        cd /tmp
        curl -sSLo ./terraform-docs.tar.gz https://terraform-docs.io/dl/${{ inputs.tfdoc_version }}/terraform-docs-${{ inputs.tfdoc_version }}-$(uname)-amd64.tar.gz
        tar -xzf terraform-docs.tar.gz
        chmod +x terraform-docs
        sudo mv terraform-docs /usr/local/bin/terraform-docs

    - name: Print Terraform Docs Version
      run: terraform-docs --version
    
    - name: Terraform Docs Check
      run: terraform-docs -c ${{ inputs.config_file }} --output-check ${{ inputs.directory }} 
```

Here we download the binary passed in via the calling workflow input, which at the time of writing is `v0.19.0` which is passed to the URL which uses `curl` to then download it, extract it using `tar`, make it executable and then move it into a directory that is in `$PATH`. 

!!! note
    I could use the `$GITHUB_PATH` environment variable to append a new directory to the $PATH, but my own Linux experience is to move user owned binaries into the `/usr/local/bin` directory.

We then confirm the version as part of the workflow, pass in the config file and then use the `--output-check` flag which returns which locations haven't been updated based on the latest OpenTofu configuration.
