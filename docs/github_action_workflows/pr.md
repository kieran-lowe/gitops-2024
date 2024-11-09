# PR

This is the core workflow that orchestrates other reusable workflows to ensure all required checks run in each PR. This is a combination of:

- [OpenTofu Format Checks (`tofu fmt`)][opentofu]
- [OpenTofu Native Testing Checks (using `tofu test`)][opentofu]
- [OpenTofu Validation Checks (`tofu validate`)][opentofu]
- [OpenTofu Plan (`tofu plan`)][opentofu]
- [Infracost](https://www.infracost.io/)
- SAST (Static Application Security Testing)
    - [checkov](https://www.checkov.io/)
    - [Trivy](https://trivy.dev/)
- Linters
    - [markdownlint](https://github.com/DavidAnson/markdownlint)
    - [tflint](https://github.com/terraform-linters/tflint)
- [terraform-docs](https://terraform-docs.io/)

!!! note
    You may notice OpenTofu Apply (`tofu apply`) hasn't been mentioned above. This is because this is done following a merge to the base branch using GitHub Environments!

The workflow is presented below:

``` { .yaml title=".github/workflows/pr.yml" linenums="1" }
--8<-- ".github/workflows/pr.yml"
```

## Configuration

As this is the first Action we're seeing. Lets breakdown some commonality you'll see amongst all workflows:

**Name**

``` { .yaml linenums="1" }
name: PR
```

Quite self explanatory - name of the GitHub Action.

**On**

``` { .yaml linenums="1" }
on:
  pull_request:
    types: [opened, reopened, synchronize]
    branches:
      - dev
      - main
    paths:
      - 'tofu/**'
```

Without starting a fight on the right way of defining a list in `yaml` so I did both :grin:, this workflow only runs under the following conditions:

1. Is a pull request
2. Whether that pull request is `opened`, `reopened` or synchronised (`synchronize`)
3. If the target branch is either `dev` or `main`
4. Only if the pull request has changes to anything inside the `tofu/` directory

!!! info
    **All** of these conditions must be true before the Action will execute!

**Permissions**

``` { .yaml linenums="1" }
permissions:
  contents: read
```

`permissions` can be set at the workflow level and job level. With the job level taking precedence. This is a basic permissions, which gives the workflow permission to, say, use the `checkout` GitHub Action to pull the code down.

**Defaults**

``` { .yaml linenums="1" }
defaults:
  run:
    shell: bash
```

`defaults` is used to set any default for all jobs and steps. In this case, it will ensure each step/command runs in the `bash` shell.

### Jobs

``` { .yaml linenums="1" }
# <truncated>
jobs:
  tofu-checks:
    permissions:
      contents: read
      id-token: write
      pull-requests: write
    uses: ./.github/workflows/tofu_checks.yml
    with:
      tf_var_file: "${{ github.base_ref == 'main' && 'prod' || 'dev' }}.tfvars"
# <truncated>
```

I won't go into too much detail about what jobs are and all the available arguments. You can find all that information out here: <https://docs.github.com/en/actions/writing-workflows/workflow-syntax-for-github-actions#jobs>.

I will cover this first one, and then the rest of the document will follow the order of the PR workflow jobs covering each workflow and its intended purpose.

**Job ID**

`tofu-checks` is the name of the specific job.

**Job Permissions**

This reusable action also requires additional permissions, so like I mentioned before I have specified permissions at the `job` level - which takes precedence.

1. `contents` is set at `read` so the PR can be checked out
2. `id-token` is set as `write` so the JWT (JSON Web Token using OIDC (OpenID Connect)) can be requested to authenticate with AWS (*this action requires `tofu init` to be ran*)
3. `pull-requests` is set as `write` as it will post a comment to the PR with status checks

!!! warning
    I could technically place this at the root of the workflow, but that would mean ALL jobs would have these permissions. To adhere to the principal of least privilege, I'm only specifying additional permissions for each job that *actually* needs them!

**Uses**

The `uses` keyword points to another workflow (reusable) to run. It is defined at the following path: `./.github/workflows/tofu_checks.yml`

!!! info
    You might notice that a commit sha, or version is not specified. In this case, the workflow in GitHub Actions shows the following: `kieran-lowe/gitops-2024/.github/workflows/tofu_plan.yml@refs/pull/57/merge` - as this workflow is part of my repo anyway, I haven't specified anything:

    ``` { .yaml linenums="8" }
    uses: ./.github/workflows/tofu_checks.yml
    ```

**With**

The `with` keywords allows you to pass in inputs to the reusable workflow, in this case `tf_var_file` which the `./.github/workflows/tofu_checks.yml` workflow expects.

``` { .yaml linenums="26" }
with:
  tf_var_file: "${{ github.base_ref == 'main' && 'prod' || 'dev' }}.tfvars"
```

As there are two environments: `dev` and `prod` we use some conditional logic using the [`github` context](https://docs.github.com/en/actions/writing-workflows/choosing-what-your-workflow-does/accessing-contextual-information-about-workflow-runs#github-context). The conditional works like this: `${{ condition && is_truthy || is_false }}`

Now lets go into the jobs! We have 6 in total for this workflow:

1. [tofu-checks](#tofu-checks)
2. [tofu-plan](#tofu-plan)
3. [sast-checks](#sast-checks)
4. [linters](#linters)
5. [terraform-docs](#terraform-docs)
6. [infracost](#infracost)

!!! note
    Each additional job/workflow has been documented in its own area to avoid making this page huge. The links for each are below!

#### tofu-checks

- Please visit: [Tofu Checks](./tofu_checks.md)

#### tofu-plan

- Please visit: [Tofu Plan](./tofu_plan.md)

#### sast-checks

- Please visit: [SAST Checks](./sast.md)

#### linters

- Please visit: [Linter Checks](./linters.md)

#### terraform-docs

- Please visit: [Terraform Docs Check](./terraform_docs.md)

#### infracost

- Please visit: [Infracost](./infracost.md)

!!! info
    You may notice additional workflows in the navigation menu. These are not called by this main orchestrator and run on their own cadences!

[opentofu]: https://opentofu.org/
