# 📘 Lessons Learned in this Project

## 🛠️ Problem 1: GitHub Actions workflow was not running

 - **Why it happened**: I had placed the `.github/workflows` directory (which contains GitHub Actions `.yml` files) inside a subfolder instead of the root of the repository. GitHub requires this folder to be at the root level in order to detect and run workflows.

- **Steps I took to fix it**: I reviewed the expected structure for GitHub Actions, compared it with working examples, and confirmed that the folder was misplaced.

- **How I resolved it**: I moved the `.github/workflows/` directory to the root of the repository, committed the changes, and the pipeline started executing as expected.

- **Why this matters**: If GitHub can’t detect your workflow, your entire CI/CD automation fails silently. Making sure your project follows the expected directory structure is essential to avoid confusion and delays.

---

## 🛠️ Problem 2: terraform fmt was consistently failing in the pipeline

- **Why it happened**: I assumed `terraform fmt` would auto-format the code and pass in the pipeline, but the pipeline failed because the `.tf` files were improperly formatted. There was also a reference to a non-existent `terraform.yml` file.

- **Steps I took to fix it**: I reviewed the pipeline logs, manually ran `terraform fmt -check -recursive` locally, and inspected the affected files.

- **How I resolved it**: I applied the fixes locally, added and committed the changes, then re-ran the pipeline. This time, the format check passed.

- **Why this matters**: Misformatted files can break automation and create inconsistencies. Keeping clean formatting not only ensures pipelines succeed but also improves readability and collaboration.

---

## 🛠️ Problem 3: Terraform referenced an undeclared resource

- **Why it happened**: In my `main.tf`, I referenced `aws_security_group.allow_ssh_http.id`, but never actually declared that security group.

- **Steps I took to fix it**: I reviewed the error message, located the line causing the issue, and confirmed the missing resource.

- **How I resolved it**: I added the following resource to my Terraform configuration:

```
resource "aws_security_group" "allow_ssh_http" {
  name        = "allow_ssh_http"
  description = "Allow SSH and HTTP inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh_http"
  }
}
```
- **Why this matters**: Terraform requires all referenced resources to be declared. This issue taught me to always validate the full dependency graph and run terraform validate to catch these errors early.

---
## 🛠️ Problem 4: Docker didn’t start on the EC2 instance

- **Why it happened**: The AMI (Amazon Linux 2) installs Docker using `amazon-linux-extras install`, but doesn’t enable or start the service by default. Also, u`sermod -a -G docker ec2-user` doesn't apply until after a session restart.

- **Steps I took to fix it**: I researched how Amazon Linux handles Docker and how user_data scripts execute.

- **How I resolved it**: I replaced my `user_data script `with the following:

```
#!/bin/bash
yum update -y
amazon-linux-extras enable docker
amazon-linux-extras install -y docker
systemctl enable docker
systemctl start docker
docker run -d -p 80:80 nginx
```

- **Why this matters**: If Docker doesn't start properly, the container never runs and there’s no clear indication of failure unless you log in and check. This taught me the importance of verifying service readiness in automation scripts.

---

## 🛠️ Problem 5: Couldn’t destroy infrastructure with terraform destroy

- **Why it happened**: The `terraform.tfstate` file was stored locally in a GitHub Actions ephemeral runner. Once the runner finished, the state file was lost, so Terraform no longer had knowledge of the deployed infrastructure.

- **Steps I took to fix it**: I researched how to store state remotely and securely. I found that S3 combined with DynamoDB locking was a recommended practice.

- **How I resolved it**: I configured a remote backend in S3 and added a DynamoDB table for state locking to prevent conflicts between executions.

- **Why this matters**: Losing your state file means Terraform has no idea what’s been deployed, which can lead to orphaned infrastructure and unexpected AWS charges. This experience emphasized the need for persistent, shared backend storage.

---
## 🛠️ Problem 6: GitHub rejected a file larger than 100MB

- **Why it happened**: A large binary file from the `.terraform` directory was accidentally committed. GitHub doesn't allow files larger than `100MB` in regular repositories.

- **Steps I took to fix it**: I removed the file with `git rm`, added it to `.gitignore`, but the push still failed due to the file’s presence in commit history. I had to fully remove it from the Git history.

- **How I resolved it**: I installed `git-filter-repo` and ran:

```
git filter-repo --force \
  --path bootstrap/.terraform/providers/.../terraform-provider-aws_v6.9.0_x5 \
  --invert-paths
```
Then, I reconfigured the remote and pushed with force:
```
git push --set-upstream origin main --force
```
- **Why this matters**: Binary files in Git history can completely block collaboration or CI/CD. It’s crucial to avoid committing auto-generated or provider files and always use `.gitignore` effectively.

---
## 🛠️ Problem 7: GitHub Codespaces secrets weren’t available

- **Why it happened**: I added the secrets after the Codespace was already running, and they don’t auto-update in existing environments.

- **Steps I took to fix it**: I read GitHub’s Codespaces documentation and found that secrets are injected only on startup.

- **How I resolved it**: I manually stopped and restarted the Codespace. Once restarted, the secrets were available as environment variables (e.g. `$AWS_ACCESS_KEY_ID`).

- **Why this matters**: Misconfigured or missing secrets can block Terraform and CLI tools from working. This helped me understand how GitHub Codespaces handles secrets lifecycle.

---
## 🛠️ Problem 8: NGINX page wasn't loading

- **Why it happened**: I mistakenly tried to access the server using `https://`, but the NGINX container was only serving traffic via HTTP.

- **Steps I took to fix it**: I tested using `curl http://<public-ip> `and got a valid response, confirming the server was running.

- **How I resolved it**: I switched from `https://` to `http://` in the browser and the page loaded correctly.

- **Why this matters**: This is a small but common mistake that can waste time. Verifying service accessibility with tools like `curl` can quickly isolate issues from infrastructure vs. user error.

---

## ✅ Final Validation & Cleanup

Once everything was working as expected, I verified that the `terraform.tfstate` file was correctly stored in my AWS S3 bucket.

I then triggered the `destroy` GitHub Action manually to tear down the infrastructure.

Finally, I checked my AWS account manually to confirm that no services or resources remained active, in order to avoid unnecessary charges.

- **Why this matters**: Verifying that the remote state is being stored correctly and manually auditing your cloud environment after destruction is a best practice. It ensures your automation is working as intended and helps prevent unexpected billing due to orphaned resources.

---
```
