# docker-aws-backup
Docker app for backup EBS volumes on AWS

## USAGE

```
docker run --rm -it -e SNAPSHOTS_TO_KEEP=10 -e AWS_ACCESS_KEY=XXX -e AWS_SECRET_KEY=YYY opsway/aws_backup PROJECT_NAME vol-ID VOLUME_NAME ap-south-1 [OPTIONAL_TAG]
```
