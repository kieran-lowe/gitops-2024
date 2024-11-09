# Linter Checks

This workflow is called by the `pr.yml` workflow to run linter checks against code in each PR. The linters in use are:

1. [markdownlint](https://github.com/DavidAnson/markdownlint)
2. [tflint](https://github.com/terraform-linters/tflint)
3. [cspell](https://github.com/streetsidesoftware/cspell)

!!! note
    This page covers the GitHub Action Workflow and not the tool itself. If you are interested in the tool itself, you can go to the links above, or visit: [Toolchain](../repository/toolchain.md), where I talk about the toolchain used in this project.

## Calling Workflow

``` { .yaml title=".github/workflows/pr.yml" linenums="42" }
linters:
  permissions:
    contents: read
    id-token: write
    pull-requests: write
  uses: ./.github/workflows/linters.yml
```

## Workflow

``` { .yaml title=".github/workflows/linters.yml" linenums="1" } 
--8<-- ".github/workflows/linters.yml"
```

## Configuration

This workflow is reusable, denoted by the `workflow_call` directive in the workflow and has no inputs.

It requires three different permissions which are granted from the caller workflow:

1. To get the PR branch (`contents: read`)
2. To initialise OpenTofu, therefore needing to authenticate with AWS using the deployment role (`id-token: write`)
3. Post a comment of the results of the checks to the PR (`pull-requests: write`)

``` { .yaml title=".github/workflows/pr.yml" linenums="43" }
permissions:
  contents: read
  id-token: write
  pull-requests: write
```

### Jobs

This workflow has 4 jobs:

1. [markdownlint](#markdownlint)
2. [tflint](#tflint)
3. [cspell](#cspell)
4. [post-comment](#post-comment)

#### markdownlint

``` { .yaml title=".github/workflows/linters.yml" linenums="5" }
markdownlint:
  runs-on: ubuntu-latest
  steps:
    - name: Check Out Code
      uses: actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683 # v4.2.2

    - name: Run Markdownlint
      uses: DavidAnson/markdownlint-cli2-action@db43aef879112c3119a410d69f66701e0d530809 # v17.0.0
```

This job simply runs the markdownlint cli action from the author of markdownlint.

#### tflint

``` { .yaml title=".github/workflows/linters.yml" linenums="14" }
tflint:
  runs-on: ubuntu-latest
  steps:
    - name: Check Out Code
      uses: actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683 # v4.2.2

    - name: Setup TFLint
      uses: terraform-linters/setup-tflint@19a52fbac37dacb22a09518e4ef6ee234f2d4987 # v4.0.0
      with:
        tflint_version: latest

    - name: Print TFLint Version
      run: tflint --version

    - name: Init TFLint
      run: tflint --init
      env:
        # https://github.com/terraform-linters/tflint/blob/master/docs/user-guide/plugins.md#avoiding-rate-limiting
        GITHUB_TOKEN: ${{ github.token }}

    - name: Run TFLint
      run: tflint --chdir=.
      working-directory: ${{ github.workspace }}/tofu
```

`tflint` uses the official action from the authors which installs the tool, following which we use normal CLI commands to run it as you would in your local terminal. The `env` variable here is to use the token of the runner to make an authenticated request to the GitHub APIs as tflint does its initialisation process. While you can make unauthenticated requests, you will eventually be rate limited.

Lastly we just tell tflint to run inside the `tofu` directory where it needs to run.

#### cspell

``` { .yaml title=".github/workflows/linters.yml" linenums="38" }
cspell:
  runs-on: ubuntu-latest
  steps:
    - name: Check Out Code
      uses: actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683 # v4.2.2
      with:
        ref: ${{ github.event.pull_request.head.ref }}

    - name: Run cspell
      uses: streetsidesoftware/cspell-action@9759be9ad475fe8145f8d2a1bf29a1c4d1c6f18d # v6.9.0
      with:
        files: .*/**/*.md
        config: .cspell.yml
```

Using the official action from the cspell authors, we tell it to look for all markdown files. Following which we pass in a config file located at the root of the repo to configure additional behaviour.

!!! note
    To learn more about the config you can visit the [Toolchain](../repository/toolchain.md) page. We could configure custom dictionaries for this tool as well, however having used the tool in the past a lot of the functions in Terraform are flagged. To keep it simple, I scoped this tool to look at markdown files only.

#### post-comment

``` { .yaml title=".github/workflows/linters.yml" linenums="52" }
post-comment:
  runs-on: ubuntu-latest
  needs: [markdownlint, tflint, cspell]
  steps:
    - name: Post Comment
      uses: actions/github-script@60a0d83039c74a4aee543508d2ffcb1c3799cdea # v7.0.1
      with:
        script: |
          const markdownlintResult = `**Markdownlint:** ${{ needs.markdownlint.result }}`;
          const tflintResult = `**TFLint:** ${{ needs.tflint.result }}`;
          const cspellResult = `**cspell:** ${{ needs.cspell.result }}`;
          const commentBody = `## Linter Checks Result\n\n${markdownlintResult}\n${tflintResult}\n${cspellResult}`;

          const { data: comments } = await github.rest.issues.listComments({
            owner: context.repo.owner,
            repo: context.repo.repo,
            issue_number: context.issue.number,
          });

          const botComment = comments.find(comment => comment.user.login === 'github-actions[bot]' && comment.body.includes("## Linter Checks Result"));

          if (!botComment) {
            await github.rest.issues.createComment({
              owner: context.repo.owner,
              repo: context.repo.repo,
              issue_number: context.issue.number,
              body: commentBody,
            });
          } else {
            await github.rest.issues.updateComment({
              owner: context.repo.owner,
              repo: context.repo.repo,
              comment_id: botComment.id,
              body: commentBody,
            });
          }
```

Like other Actions I have authored, we use the `github-script` action to take the results of previous jobs, and then output that as a comment on the PR confirming success or failure. If a comment already exists, then it simply updates as opposed to creating a new one and cluttering up the PR.
