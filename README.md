# Upload files to S3
- upload folder
s3cmd put --recursive images/watermark s3://cdn.dennyzhang.com/

- upload file
s3cmd put test.html s3://cdn.dennyzhang.com/
s3cmd put images/github_screenshot/demo_jenkins.png s3://cdn.dennyzhang.com/

- upload everything
s3cmd --exclude=".git/*" sync . s3://cdn.dennyzhang.com/

curl -I https://d2blpr6and0yku.cloudfront.net/images/denny/devops_slack.jpg
curl -I https://cdn.dennyzhang.com/images/denny/devops_slack.jpg

# Add watermark for a given file
composite -dissolve 50% -gravity northeast -quality 100 /Users/mac/Dropbox/private_data/project/devops_consultant/consultant_code/blog/blog_cdn/images/watermark/dns.png demo_jenkins.png ../../github_screenshot/demo_jenkins.png

# Add Github watermark
composite -dissolve 50% -gravity northeast -quality 100 /Users/mac/Dropbox/private_data/project/devops_consultant/consultant_code/blog/blog_cdn/images/watermark/github.png github_audit_hostsfile.png github_audit_hostsfile.png

composite -dissolve 50% -gravity southeast -quality 100 /Users/mac/Dropbox/private_data/project/devops_consultant/consultant_code/blog/blog_cdn/images/watermark/dns.png github_audit_hostsfile.png github_audit_hostsfile.png

s3cmd put github_audit_hostsfile.png s3://cdn.dennyzhang.com/images/blog/