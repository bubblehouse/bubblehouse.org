## bubblehouse.org
### Jekyll Port

I'm in the process of consolidating my various online presences onto AWS services. To
reduce EC2 usage, I've moved my blog to a Jekyl-based statically generated site.

It automatically loads all my Gists as posts specially formatted with redcarpet's
code fencing blocks, and uses s3website to upload them to a CloudFront-backed
S3 bucket, which also takes care of expiring the CloudFront cache.