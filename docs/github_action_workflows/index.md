# GitHub Action Workflows

Full CI/CD functionality is done in GitHub Actions. Each section below contains documentation covering what each workflow does and the purpose it solves. Workflows used are a combination of static and reusable.

To keep it simple, all of these Actions are using the `ubuntu-latest` GitHub-hosted Action Runners denoted by the `runs-on:` keyword.

## Using "commit SHAs" instead of "Git tags"

As you read this page, you will see I'm using commit SHAs for each external GitHub Action instead of the appropriate git tag, normally based on the [semver standard](https://semver.org/). This is more of a security decision and tools such as checkov and trivy can actually analyse your workflows and recommend you do this too. This is to help mitigate against supply chain attacks. 

A git tag is just a pointer to a specific commit SHA, these tags can be updated to point at a new reference if forced pushed by someone with appropriate permissions. As a result, Git tags are not **immutable**. So if you reference `v1` which points to `a12b3c4d`, then someone updates the `v1` tag to `d56e7f8g9h` then your workflow will point to the new commit. While this helps get updates quickly, it could mean your workflow is running code that you've not validated. More importantly, if the new pointer has something malicious, then it could cause serious impact.

You can see examples of this below:

``` { .yaml .annotate title="Examples" linenums="1" } 
- name: Check Out Code
  uses: actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683 # v4.2.2 (1)

- name: Configure OpenTofu
  uses: opentofu/setup-opentofu@12f4debbf681675350b6cd1f0ff8ecfbda62027b # v1.0.4

- name: Create Issue if Drift Detected
  if: steps.plan-dev.outputs.exitcode == 2
  uses: actions/github-script@60a0d83039c74a4aee543508d2ffcb1c3799cdea # v7.0.1
```

1. I've added a comment of the tag the commit sha points to, which helps developers know what version of an action is ran. In this case it is `v4.2.2` of the official `checkout` GitHub action.
