# Tofu Destroy

This workflow is very similar to the [Tofu Apply](./tofu_apply.md) workflow, with the only difference is runs `tofu destroy` instead of `tofu apply`. 

!!! warning
    The GitHub Environment has a condition that any workflow MUST be approved before it can be ran inside. This obviously then stops anyone just destroying anything without human intervention.
    
    ***This will destroy all infrastructure inside the destination environment.***

## Workflow

``` { .yaml title=".github/workflows/tofu_destroy.yml" linenums="1" } 
--8<-- ".github/workflows/tofu_destroy.yml"
```

## Configuration

This workflow will only run on a push to `dev` and `main` which correspond to our two environments in AWS. Additionally it will only run if the `tofu/` directory has been updated as that is where the OpenTofu configuration is. It uses two environment variables that help tailor the output of messages to the system the tool is interacting with, such as a CI/CD Pipeline where it's non interactive.

Here we use the `environment` keyword to tell the workflow that it will run in a GitHub Environment. As we only have two environments, we use a condition using the `ref_name` in the `github` context. If the workflow is running inside the `main` branch, we know the environment is `prod`, otherwise if it is running in `dev` we know the environment is `dev`

!!! note
    As an improvement I would make this more dynamic and not just for two environments.

As we need to authenticate with AWS, we need to grant the `id-token: write` permission so we can request the JWT using OIDC. The `contents: read` permission is to allow the PR branch to be checked out. 

As mentioned in [Tofu Checks](./tofu_checks.md), we use the `TF_IN_AUTOMATION` and `TF_INPUT` environment variables to control the output OpenTofu shows to the user. In this case a non-interactive CI/CD pipeline.

### Jobs

There is only one job in this workflow:

1. [destroy](#destroy)

#### destroy

``` { .yaml title=".github/workflows/tofu_destroy.yml" linenums="19" } 
destroy:
  runs-on: ubuntu-latest
  environment: ${{ github.ref_name == 'main' && 'prod' || 'dev' }}
  steps:
    - name: Check Out Code
      uses: actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683 # v4.2.2

    - name: Configure OpenTofu
      uses: opentofu/setup-opentofu@12f4debbf681675350b6cd1f0ff8ecfbda62027b # v1.0.4

    - name: Print Tofu Version
      run: tofu --version

    - name: Get OIDC Token File
      run: |
        curl -s -H "Authorization: bearer $ACTIONS_ID_TOKEN_REQUEST_TOKEN" "$ACTIONS_ID_TOKEN_REQUEST_URL&audience=sts.amazonaws.com" | jq -r .value > /tmp/web-identity-token

    - name: Tofu Init
      run: tofu init --backend-config="key=${{ github.event.repository.name }}/${{ github.ref_name == 'main' && 'prod' || 'dev' }}/terraform.tfstate" --var-file="${{ github.ref_name == 'main' && 'prod' || 'dev' }}.tfvars"
      working-directory: ${{ github.workspace }}/tofu

    - name: Tofu Destroy
      run: tofu destroy --var-file="${{ github.ref_name == 'main' && 'prod' || 'dev' }}.tfvars" --no-color --auto-approve
      working-directory: ${{ github.workspace }}/tofu
```

The base branch is checked out and then OpenTofu is installed into the environment using their official Action. We confirm the version of OpenTofu being used in the workflow, and then request the OIDC Token File to authenticate with AWS. 

After we initialise OpenTofu to download the providers used: `aws` and `http`. You might also notice we're using a partial backend here, as we have the workflow managing the `key` to the state file. We could technically pass in a .hcl file that also has the backend configuration, but wanted to make the OpenTofu workflow as simple as possible.

The destroy is then automatically ran and infrastructure is deployed into the destination environment.
