# docker-aws-backup
Docker ruby application for backup & clean up any EBS volumes on AWS

## USAGE

```
docker run --rm -it -e SNAPSHOTS_TO_KEEP=10 -e AWS_ACCESS_KEY=XXX -e AWS_SECRET_KEY=YYY opsway/aws-backup PROJECT_NAME vol-ID VOLUME_NAME ap-south-1 [OPTIONAL_TAG]
```
