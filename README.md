# Train Ticket: A New Version

## Introduction

The legacy version of Train Ticket has become outdated and suffered from a lack of maintenance. In response, we've developed a new, more advanced version.

## What's New

- Simplified Development and Deployment: We've streamlined the process, ensuring full integration with Kubernetes (k8s) and Helm for a smoother experience.
- Pruned Redundancies: Certain components that no longer served a purpose have been removed to enhance efficiency.
- Enhanced Monitoring: Comprehensive monitoring capabilities have been integrated, including tools like SkyWalking, OpenTelemetry, Kindling, and DeepFlow, to ensure robust performance insights.

## Development Guide

To get started with development, you'll need to set up a few tools:

1. Install [helm](https://helm.sh/docs/intro/install/) for managing Kubernetes applications.
2. Install [skaffold](https://skaffold.dev/docs/install/) for a streamlined workflow that includes building, pushing, and deploying applications.
3. Install [minikube](https://minikube.sigs.k8s.io/docs/start/) for running Kubernetes locally.

After setting up the necessary tools, you can deploy your application using Skaffold:

```bash
mvn clean package -Dmaven.test.skip=true
skaffold run
skaffold build --default-repo=10.10.10.240/library # push to the local repository
```

## Deployment Instructions

For deployment, the primary requirement is Helm:

1. Ensure Helm is installed.
2. To deploy the application, use the following Helm command:

```bash
helm install ts manifests/helm/generic_service -n ts --create-namespace --set global.monitoring=opentelemtry --set skywalking.enabled=false --set global.image.tag=3384da1c # your image tag

# if use prebuild images:
helm install ts manifests/helm/generic_service -n ts --create-namespace --set global.monitoring=opentelemtry --set skywalking.enabled=false --set global.image.tag=latest --set global.image.repository=registry.cn-shenzhen.aliyuncs.com/lincyaw


# use apo
helm upgrade ts manifests/helm/generic_service -n ts-dev --create-namespace --set global.monitoring=opentelemtry --set opentelemtry.enabled=false --set services.tsUiDashboard.nodePort=30081 --set global.image.tag=310a67e0

# uninstall
helm uninstall ts -n ts
```

Note: If you change the release name, you must also update the values.yaml file accordingly. For instance, when disabling the PostgreSQL component for demo purposes (not recommended for production), ensure you configure the host to match your PostgreSQL service's hostname, as shown below:

```yaml
postgresql:
  enabled: false # To disable the demo PostgreSQL deployment (not for production use).
  config:
    # Specify your PostgreSQL service's hostname (effective when postgresql.enabled is false).
    host: ts-postgresql # Important: Update this to match your service name!
  auth:
```

This new version is designed to offer a more streamlined, efficient, and powerful solution for managing train ticket services, leveraging the latest in technology and best practices.
=======
# Train Ticket



## Getting started

To make it easy for you to get started with GitLab, here's a list of recommended next steps.

Already a pro? Just edit this README.md and make it your own. Want to make it easy? [Use the template at the bottom](#editing-this-readme)!

## Add your files

- [ ] [Create](https://docs.gitlab.com/ee/user/project/repository/web_editor.html#create-a-file) or [upload](https://docs.gitlab.com/ee/user/project/repository/web_editor.html#upload-a-file) files
- [ ] [Add files using the command line](https://docs.gitlab.com/ee/gitlab-basics/add-file.html#add-a-file-using-the-command-line) or push an existing Git repository with the following command:

```
cd existing_repo
git remote add origin https://gitlab.com/tjs392/train-ticket.git
git branch -M main
git push -uf origin main
```

## Integrate with your tools

- [ ] [Set up project integrations](https://gitlab.com/tjs392/train-ticket/-/settings/integrations)

## Collaborate with your team

- [ ] [Invite team members and collaborators](https://docs.gitlab.com/ee/user/project/members/)
- [ ] [Create a new merge request](https://docs.gitlab.com/ee/user/project/merge_requests/creating_merge_requests.html)
- [ ] [Automatically close issues from merge requests](https://docs.gitlab.com/ee/user/project/issues/managing_issues.html#closing-issues-automatically)
- [ ] [Enable merge request approvals](https://docs.gitlab.com/ee/user/project/merge_requests/approvals/)
- [ ] [Set auto-merge](https://docs.gitlab.com/ee/user/project/merge_requests/merge_when_pipeline_succeeds.html)

## Test and Deploy

Use the built-in continuous integration in GitLab.

- [ ] [Get started with GitLab CI/CD](https://docs.gitlab.com/ee/ci/quick_start/)
- [ ] [Analyze your code for known vulnerabilities with Static Application Security Testing (SAST)](https://docs.gitlab.com/ee/user/application_security/sast/)
- [ ] [Deploy to Kubernetes, Amazon EC2, or Amazon ECS using Auto Deploy](https://docs.gitlab.com/ee/topics/autodevops/requirements.html)
- [ ] [Use pull-based deployments for improved Kubernetes management](https://docs.gitlab.com/ee/user/clusters/agent/)
- [ ] [Set up protected environments](https://docs.gitlab.com/ee/ci/environments/protected_environments.html)

***

# Editing this README

When you're ready to make this README your own, just edit this file and use the handy template below (or feel free to structure it however you want - this is just a starting point!). Thanks to [makeareadme.com](https://www.makeareadme.com/) for this template.

## Suggestions for a good README

Every project is different, so consider which of these sections apply to yours. The sections used in the template are suggestions for most open source projects. Also keep in mind that while a README can be too long and detailed, too long is better than too short. If you think your README is too long, consider utilizing another form of documentation rather than cutting out information.

## Name
Choose a self-explaining name for your project.

## Description
Let people know what your project can do specifically. Provide context and add a link to any reference visitors might be unfamiliar with. A list of Features or a Background subsection can also be added here. If there are alternatives to your project, this is a good place to list differentiating factors.

## Badges
On some READMEs, you may see small images that convey metadata, such as whether or not all the tests are passing for the project. You can use Shields to add some to your README. Many services also have instructions for adding a badge.

## Visuals
Depending on what you are making, it can be a good idea to include screenshots or even a video (you'll frequently see GIFs rather than actual videos). Tools like ttygif can help, but check out Asciinema for a more sophisticated method.

## Installation
Within a particular ecosystem, there may be a common way of installing things, such as using Yarn, NuGet, or Homebrew. However, consider the possibility that whoever is reading your README is a novice and would like more guidance. Listing specific steps helps remove ambiguity and gets people to using your project as quickly as possible. If it only runs in a specific context like a particular programming language version or operating system or has dependencies that have to be installed manually, also add a Requirements subsection.

## Usage
Use examples liberally, and show the expected output if you can. It's helpful to have inline the smallest example of usage that you can demonstrate, while providing links to more sophisticated examples if they are too long to reasonably include in the README.

## Support
Tell people where they can go to for help. It can be any combination of an issue tracker, a chat room, an email address, etc.

## Roadmap
If you have ideas for releases in the future, it is a good idea to list them in the README.

## Contributing
State if you are open to contributions and what your requirements are for accepting them.

For people who want to make changes to your project, it's helpful to have some documentation on how to get started. Perhaps there is a script that they should run or some environment variables that they need to set. Make these steps explicit. These instructions could also be useful to your future self.

You can also document commands to lint the code or run tests. These steps help to ensure high code quality and reduce the likelihood that the changes inadvertently break something. Having instructions for running tests is especially helpful if it requires external setup, such as starting a Selenium server for testing in a browser.

## Authors and acknowledgment
Show your appreciation to those who have contributed to the project.

## License
For open source projects, say how it is licensed.

## Project status
If you have run out of energy or time for your project, put a note at the top of the README saying that development has slowed down or stopped completely. Someone may choose to fork your project or volunteer to step in as a maintainer or owner, allowing your project to keep going. You can also make an explicit request for maintainers.
