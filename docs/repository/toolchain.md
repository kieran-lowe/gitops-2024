# Toolchain

This page documents what tools I used in this Minicamp that GitHub Actions runs!

## OpenTofu

OpenTofu is the IaC tool used to deploy the infrastructure into the AWS accounts! It is the pure open-source fork of HashiCorp's Terraform where it changed its license to BSL (Business Source License) which sparked outrage in the community. I don't want to start a war on OpenTofu vs Terraform, but OpenTofu has been making some awesome changes that the Terraform community has been asking for a very long time, some examples:

1. Native integration for state/plan file encryption
2. Early variable evaluation
3. Very new in the latest Alpha version for 1.9.0 - `for_each` at the `provider` level

You should make your own decision on what tool you want to use, but competition is good for all of as consumers!

- <https://opentofu.org/>

## Infracost

Infracost is a FinOps tool that integrates with CI/CD pipelines to bring the cost topic at the point changes are made to infrastructure, which are Pull Requests. While we used the free offering for this Minicamp, it does have a SaaS product where you can create custom policies, dashboards and more.

- <https://www.infracost.io/>

## Open Policy Agent

OPA is a Policy-as-Code engine that defines policies using Rego. We create a rego policy as part of this camp, but it is only used in the scope of Infracost integration. It is backed by the Cloud Native Computing Foundation and is fully open-source

- <https://www.openpolicyagent.org/>

## checkov

checkov is a SAST tool that scans your configuration for best practices and potential security issues. It has a massive amount of checks and scans for things such as:

1. Overpermissive IAM policies
2. Delete protection enabled on DynamoDB tables
3. Public resource exposure
4. Port 22 open to the world

- <https://www.checkov.io/>

## Trivy

Trivy is similar to `checkov` - it scans your code for best practices and potential security issues. It can even scan your workflows to make sure they are secure, such as using commit SHAs to prevent supply-chain attacks.

- <https://trivy.dev/>

## markdownlint

Markdownlint, as you might be able to tell, lints markdown documents so they are formatted to a standard across the entire repository. For example, using `*` or `_` for emphasis in text and more.

- <https://github.com/DavidAnson/markdownlint>

## tflint

tflint is used to scan your OpenTofu/Terraform for quality such as deprecations, naming conventions and best practices.

- <https://github.com/terraform-linters/tflint>

## terraform-docs

Used to produce good documentation on your OpenTofu/Terraform configuration such as versions, providers, modules, variables and their descriptions in a easy to read markdown format.

- <https://github.com/terraform-docs/terraform-docs>

## cspell

Spell check your code for spelling mistakes!

- <https://cspell.org/>

## Material for Mkdocs

A theme for the `Mkdocs` framework that builds beautiful documentation sites! Documentation-as-Code!

- <https://squidfunk.github.io/mkdocs-material/>

## pre-commit

A framework for running pre-commit hooks before they are committed to the repository.

- <https://pre-commit.com/>

## EditorConfig

A common standard for editing files in their IDE of choice such as enforcing utf-8 and Linux line endings, spacing, tabs or spaces and more!

- <https://editorconfig.org/>

## Dependabot

GitHub's native bot for updates dependencies in your code!

- <https://github.com/dependabot>
