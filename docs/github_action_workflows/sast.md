# SAST Checks

This workflow is a reusable one I made to run SAST (Static Application Security Testing) tooling. This will scan the code for best practices and potential security violations, such as:

- Ensure log groups are encrypted
- Prevent S3 public access to S3 buckets
- Ensure DynamoDB tables have delete protection and PITR (Point in time recovery) enabled

## Calling Workflow

``` { .yaml title=".github/workflows/pr.yml" linenums="39" } 
sast-checks:
  uses: ./.github/workflows/sast.yml
```

## Workflow

``` { .yaml title=".github/workflows/sast.yml" linenums="1" } 
--8<-- ".github/workflows/sast.yml"
```

## Configuration

The workflow in itself is very simple, we clone out the PR branch and install the tools and run them within their official workflows. 

### Jobs

There are two jobs for this workflow:

1. [checkov](#checkov)
2. [Trivy](#trivy)

#### checkov

``` { .yaml title=".github/workflows/sast.yml" linenums="11" } 
checkov:
  runs-on: ubuntu-latest
  steps:
    - name: Check Out Code
      uses: actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683 # v4.2.2
      with:
          ref: ${{ github.event.pull_request.head.ref }}

    - name: Run Checkov
      uses: bridgecrewio/checkov-action@99bb2caf247dfd9f03cf984373bc6043d4e32ebf # v12
      with:
        config_file: .checkov.yml
```

This workflow checks out the PR branch and then calls the official checkov GitHub Action. The behaviour of the tool is controlled through the config file present at the root of the repo: `.checkov.yml`

!!! note
    When developing this workflow I did note the official Action has not been updated in a very long time. When running it also runs a one major version of the tool itself. As I expand on improvements made to this Minicamp, I will aim to create a new one that simply installs it uses `pip`.

#### Trivy

``` { .yaml title=".github/workflows/sast.yml" linenums="23" } 
trivy:
  runs-on: ubuntu-latest
  steps:
    - name: Check Out Code
      uses: actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683 # v4.2.2
      with:
          ref: ${{ github.event.pull_request.head.ref }}

    - name: Run Trivy 
      uses: aquasecurity/trivy-action@915b19bbe73b92a6cf82a1bc12b087c9a19a5fe2 # v0.28.0
      with:
        trivy-config: .trivy.yml
        scan-type: 'config'
        exit-code: '1'
```

This workflow checks out the PR branch and then calls the official Trivy GitHub Action. The behaviour of the tool is controlled through the config file present at the root of the repo: `.trivy.yml`, however it also requires passing in additional variables to work.

!!! note
    The official Trivy action is a Docker-based GitHub Action. I've seen it takes upwards of minutes sometimes to run.
