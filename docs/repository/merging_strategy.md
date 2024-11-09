# Merging Strategy

This project implements what is called: "Apply after Merge". This means that once the PR has been approved and merged into a base branch, a workflow is kicked off which then "applies" those changes. Another way of applying infrastructure changes is "Apply before Merge" - where the `tofu apply` runs in the context of the PR following an approval. There is quite a bit more to think about here such as:

1. How do you trigger the apply?
2. Which approval do you use as the authority to trigger an apply?
3. How do you find this event information out?

There is no right or wrong way of doing this personally, as long as it is understood by everyone using your repository what you are using that is fine. I've been using Terraform, and now OpenTofu for many years and I've always done "Apply after Merge" because that is what I am used too; doesn't mean it is right, or wrong and everyone is free to have their own opinion on the matter!

For this minicamp, we create a feature branch and then raise a PR into `dev`. Once the checks have ran, and it has been approved and merged the `apply` kicks off. We then raise another PR from `dev` into `main` to deploy to production. I wanted to keep it as simple as possible :grin:
