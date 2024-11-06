# GitHub Action Workflows

Full CI/CD functionality is done in GitHub Actions. Each section below contains documentation covering what each workflow does and the purpose it solves. Workflows used are a combination of static and reusable.

## Workflows

### `pr.yml`

This is one of the core workflows that orchestrates other reusable workflows to ensure all required checks run in each PR. This is a combination of:

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
    You may notice OpenTofu Apply (`tofu apply`) hasn't been mentioned above. This is because this is done following a merge to the base branch. More information on the general CI/CD workflow can be seen here.

[opentofu]: https://opentofu.org/

### `linters.yml`

This is a reusable workflow, denoted by the `workflow_call` declaration. This workflow run the linters associated with this project. These are:

1. markdownlint
2. tflint

#### markdownlint

This tool ensures any markdown documents (including the one you are reading this on!) are compliant to a set of standards! Two files are used to control markdownlint:

1. `markdownlint.yml`

```yaml
default: true # Enable all rules by default

# Rules
# MD003: Header style
MD003:
  style: atx

# MD004: Unordered list style
MD004:
  style: dash

MD013: false

MD033:
  allowed_elements:
    - a

# MD035: Horizontal rule style
MD035:
  # Horizontal rule style
  style: ---

MD046:
  # Block style
  style: fenced

MD048:
  # Code fence style
  style: backtick

MD049:
  # Emphasis style
  style: asterisk

MD050:
  # Strong style
  style: underscore
```

#### tflint

This tool ensures your Terraform is kept to a common set of standards and as clean as possible. Such as alerting you if you have declared a `data` source but not actually used it anywhere.
